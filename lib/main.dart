import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_app/view.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:device_info/device_info.dart';
import 'package:permission_handler/permission_handler.dart';

void main()
{
      runApp(MaterialApp(debugShowCheckedModeBanner: false,home: Home(),));
}
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  final palyer =AudioPlayer();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    get_per();
    palyer.onDurationChanged.listen((Duration d){
      print("Duration : ${d}");
    });
    palyer.onPlayerStateChanged.listen((PlayerState s){
      print("state : ${s}");
    });
  }
  get_per()
  async {
    if(Platform.isAndroid)
      {
        var androidInfo = await DeviceInfoPlugin().androidInfo;
        var sdkInt = androidInfo.version.sdkInt;
        print("Sdk version : ${sdkInt}");

        if(sdkInt >=30)
          {

            var status1 = await Permission.storage.status;
            var status = await Permission.audio.status;
            if(status.isDenied || status1.isDenied)
              {
                Map<Permission, PermissionStatus> statues = await [
                  Permission.audio,
                  Permission.storage,
                ].request();
              }

          }
        else
          {
            var status = await Permission.storage.status;
            Map<Permission, PermissionStatus> statues = await [
              Permission.storage,
            ].request();
          }

      }

  }
  bool temp=false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Music App"),),
      body: FutureBuilder(future: _audioQuery.querySongs(),builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting)
        {
          return CircularProgressIndicator();
        }
        else
        {
          List<SongModel> l=snapshot.data as List<SongModel>;
          return ListView.builder(itemCount: l.length,itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                leading:  Icon(Icons.arrow_forward_ios),
                //trailing: Icon(Icons.play_arrow),
                onTap: () {
                  if(palyer.state == PlayerState.playing)
                  {
                    palyer.pause();

                  }
                  else
                  {
                    palyer.play(DeviceFileSource("${l[index].data}"));
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return view(l[index].id,l[index].displayName);
                    },));

                  }

                },
                title: Text("${l[index].displayName}"
                    // "\n ${l[index].composer}\n ${l[index].album}\n ${l[index].albumId} \n"
                    // " ${l[index].albumId} \n ${l[index].duration}"
                ),

              ),
            );
          },);
        }

      },)
    );
  }
}
