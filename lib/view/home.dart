import 'package:flutter/material.dart';
import 'package:projek_akhir/model/current.dart';
import 'package:projek_akhir/services/load_data2.dart';
import 'package:projek_akhir/view/forecast.dart';
import 'package:projek_akhir/view/login.dart';
import 'package:projek_akhir/view/register.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  LatLng? _clickedLocation;
  final MapController _mapController = MapController();
  double _zoomLevel = 13.0;
  CurrentWeather? _currentWeather;

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to LoginPage
      );
    } else {
      setState(() {
        _selectedIndex = index;
   });
  }
}

  void _updateClickedLocation(LatLng location) {
    setState(() {
      _clickedLocation = location;
      _fetchWeatherData(location);
    });
  }

  Future<void> _fetchWeatherData(LatLng location) async {
    try {
      final weatherData = await WeatherService.loadCurrentWeather(location.latitude, location.longitude);
      setState(() {
        _currentWeather = weatherData;
      });
    } catch (e) {
      print("Error fetching weather data: $e");
    }
  }

  void _zoomIn() {
    setState(() {
      _zoomLevel++;
      _mapController.move(_mapController.center, _zoomLevel);
    });
  }

  void _zoomOut() {
    setState(() {
      _zoomLevel--;
      _mapController.move(_mapController.center, _zoomLevel);
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      MapWidget(
        onMapClick: _updateClickedLocation,
        clickedLocation: _clickedLocation,
        mapController: _mapController,
        zoomLevel: _zoomLevel,
        zoomIn: _zoomIn,
        zoomOut: _zoomOut,
        currentWeather: _currentWeather,
      ),
      LoginPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center all elements vertically
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              child: _widgetOptions.elementAt(_selectedIndex),
            ),
            Expanded(
              child: Center(
                child: _selectedIndex == 0
                    ? SingleChildScrollView(
                        child: Column(
                          children: [
                            if (_clickedLocation != null)
                              // Text('Latitude: ${_clickedLocation!.latitude}, Longitude: ${_clickedLocation!.longitude}'),
                            if (_currentWeather != null)
                              WeatherDisplay(currentWeather: _currentWeather!),
                          ],
                        ),
                      )
                    : _widgetOptions.elementAt(_selectedIndex),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
      floatingActionButton: _clickedLocation != null
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WeatherForecastScreen(
                      latitude: _clickedLocation!.latitude,
                      longitude: _clickedLocation!.longitude,
                    ),
                  ),
                );
              },
              child: Icon(Icons.location_on),
            )
          : null,
    );
  }
}

class MapWidget extends StatelessWidget {
  final Function(LatLng) onMapClick;
  final LatLng? clickedLocation;
  final MapController mapController;
  final double zoomLevel;
  final VoidCallback zoomIn;
  final VoidCallback zoomOut;
  final CurrentWeather? currentWeather;

  const MapWidget({
    Key? key,
    required this.onMapClick,
    this.clickedLocation,
    required this.mapController,
    required this.zoomLevel,
    required this.zoomIn,
    required this.zoomOut,
    this.currentWeather,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            center: LatLng(-6.200000, 106.816666), // Jakarta, Indonesia
            zoom: zoomLevel,
            onTap: (tapPosition, point) {
              onMapClick(point);
            },
          ),
          children: [
            TileLayer(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
            ),
            if (clickedLocation != null)
              MarkerLayer(
                markers: [
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: clickedLocation!,
                    builder: (ctx) => Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40,
                    ),
                  ),
                ],
              ),
          ],
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Column(
            children: [
              FloatingActionButton(
                onPressed: zoomIn,
                mini: true,
                child: Icon(Icons.zoom_in),
              ),
              SizedBox(height: 8),
              FloatingActionButton(
                onPressed: zoomOut,
                mini: true,
                child: Icon(Icons.zoom_out),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class WeatherDisplay extends StatefulWidget {
  final CurrentWeather currentWeather;

  WeatherDisplay({required this.currentWeather});

  @override
  _WeatherDisplayState createState() => _WeatherDisplayState();
}

class _WeatherDisplayState extends State<WeatherDisplay> {
  late String _date;
  late String _time;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeDateTime();
  }

  @override
  void didUpdateWidget(covariant WeatherDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentWeather.location?.localtime != widget.currentWeather.location?.localtime) {
      _initializeDateTime();
    }
  }

  void _initializeDateTime() {
    final localtime = widget.currentWeather.location?.localtime;
    if (localtime != null) {
      final formattedTime = _formatTimeString(localtime);
      final dateTime = DateTime.parse(formattedTime);
      _date = '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
      _time = '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';

      // Start the timer to update time every second
      _startTimer(dateTime);
    } else {
      _date = 'Unknown date';
      _time = 'Unknown time';
    }
  }

  String _formatTimeString(String localtime) {
    final parts = localtime.split(' ');
    if (parts.length == 2) {
      final date = parts[0];
      final time = parts[1];
      final timeParts = time.split(':');
      if (timeParts.length == 2) {
        final hour = timeParts[0].padLeft(2, '0');
        final minute = timeParts[1].padLeft(2, '0');
        return '$date $hour:$minute:00';
      }
    }
    return localtime;
  }

  void _startTimer(DateTime initialDateTime) {
    _timer?.cancel(); // Cancel any existing timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        final updatedTime = initialDateTime.add(Duration(seconds: timer.tick));
        _time = '${updatedTime.hour.toString().padLeft(2, '0')}:${updatedTime.minute.toString().padLeft(2, '0')}:${updatedTime.second.toString().padLeft(2, '0')}';
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          '${widget.currentWeather.location?.name ?? 'Unknown'}, ${widget.currentWeather.location?.country ?? 'Unknown'}',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          'Date: $_date',
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 10),
        Text(
          'Time: $_time',
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        Container(
          margin: EdgeInsets.symmetric(horizontal:75),
          decoration: BoxDecoration(
            color: Colors.lightBlue.withOpacity(0.3), // Background color with transparency
            borderRadius: BorderRadius.circular(10), // Border radius for rounded corners
          ),
          padding: EdgeInsets.all(10),
          // margin: EdgeInsets.symmetric(horizontal: 20), // Padding inside the container
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.currentWeather.current?.condition?.icon != null)
                    Image.network('https:${widget.currentWeather.current!.condition!.icon}'),
                  SizedBox(width: 10),
                  Text(
                    '${widget.currentWeather.current?.tempC ?? 'N/A'}°C',
                    style: TextStyle(fontSize: 32),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                widget.currentWeather.current?.condition?.text ?? 'Unknown',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

}

// class LoginPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text('Login Page Content'),
//  );
// }
// }