import 'package:flutter/material.dart';
import 'package:map_view/camera_position.dart';
import 'package:map_view/location.dart';
import 'package:map_view/map_options.dart';
import 'package:map_view/map_view.dart';
import 'package:location/location.dart';

import 'package:flutter/services.dart';
import 'package:map_view/marker.dart';
import 'package:map_view/toolbar_action.dart';

var api_key = "AIzaSyDrHKl8IxB4cGXIoELXQOzzZwiH1xtsRf4";
void main() {
  MapView.setApiKey(api_key);
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: new MapPage(),
  ));


 // runApp(new MyApp());


}

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => new _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapView mapView = new MapView();
  CameraPosition cameraPosition=new CameraPosition(Location(24.8933854, 67.0859034), 2.0);
  var staticMapProvider = new StaticMapProvider(api_key);
  Uri staticMapUri;
  LocationNew _location = new LocationNew();
  String error;
  Map<String, double> _startLocation;


  List<Marker> markers = <Marker>[
    new Marker("1", "Faisal Cantonment"
        , 24.895314, 67.136886,
        color: Colors.amber),
    new Marker("2", "National Highway", 24.886618, 67.124282,
        color: Colors.purple),
  ];

  showMap() async {
    // await getCurrentLocation();
print("show map tapped $_startLocation");

mapView.show(
    new MapOptions(
        mapViewType: MapViewType.normal,
        showUserLocation: true,
        showMyLocationButton: true,
        showCompassButton: true,
//        initialCameraPosition: new CameraPosition(
//            new Location(45.526607443935724, -122.66731660813093), 15.0),
        hideToolbar: false,
        title: "Recently Visited"),
    toolbarActions: [new ToolbarAction("Close", 1)]);

//    mapView.show(new MapOptions(
//        mapViewType: MapViewType.normal,
//        initialCameraPosition:     new CameraPosition(new Location(_startLocation["latitude"], _startLocation["longitude"]), 15.0),
//        //cameraPosition,
//       // new CameraPosition(new Location(28.420035, 77.337628), 15.0),
//        showUserLocation: true,
//        title: "Recent Location"));
//


//    mapView.setMarkers(markers);
    mapView.zoomToFit(padding: 100);

    mapView.onMapTapped.listen((_) {
      setState(() {
        mapView.setMarkers(markers);
        mapView.zoomToFit(padding: 100);
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    cameraPosition =
    new CameraPosition(new Location(24.8933854, 67.0859034), 2.0);
    staticMapUri = staticMapProvider.getStaticUri(
        new Location(24.8933854, 67.0859034), 12,
        height: 400, width: 900, mapType: StaticMapViewType.roadmap);

     getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Flutter maps"),
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Container(
            height: 300.0,
            child: new Stack(
              children: <Widget>[
                new Center(
                  child: Container(
                    child: new Text(
                      "Map should show here",
                      textAlign: TextAlign.center,
                    ),
                    padding: const EdgeInsets.all(20.0),
                  ),
                ),
                new InkWell(
                  child: new Center(
                    child: new Image.network(staticMapUri.toString()),
                  ),
                  onTap: showMap,
                )
              ],
            ),
          ),
          new Container(
            padding: new EdgeInsets.only(top: 10.0),
            child: new Text(
              "Tap the map to interact",
              style: new TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          new Container(
            padding: new EdgeInsets.only(top: 25.0),
            child: new Text(
                "Camera Position: \n\nLat: ${cameraPosition.center
                    .latitude}\n\nLng:${cameraPosition.center
                    .longitude}\n\nZoom: ${cameraPosition.zoom}"),
          ),
        ],
      ),
    );
  }


  void getLocation() async {
    print("getting location");
    Map<String, double> location;
    // Platform messages may fail, so we use a try/catch PlatformException.

    try {
      location = await _location.getLocation;

      error = null;
    } on PlatformException catch (e) {
      print("exception getting location");

      if (e.code == 'PERMISSION_DENIED') {
        error = 'Permission denied';
      } else if (e.code == 'PERMISSION_DENIED_NEVER_ASK') {
        error =
        'Permission denied - please ask the user to enable it from the app settings';
      }

      location = null;
    }

    setState(() {
      print("location is $location");
      _startLocation = location;

      if (_startLocation != null) {
        cameraPosition =
        new CameraPosition(new Location(
            _startLocation["latitude"], _startLocation["longitude"]), 2.0);

        staticMapUri = staticMapProvider.getStaticUri(
            new Location(_startLocation["latitude"], _startLocation["longitude"]), 12,
            height: 400, width: 900, mapType: StaticMapViewType.roadmap);
      }
      else
        {
          print("_startLocation is null");
        }
    });
  }
}
