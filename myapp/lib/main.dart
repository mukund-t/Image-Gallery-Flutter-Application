import 'package:typicons_flutter/typicons_flutter.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(const MyApp());

// #docregion MyApp
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // appBar: AppBar(
        //   title: const Text(
        //       'Album 571',
        //       style: TextStyle(color: Colors.black)
        //     ),
        // ),
      body: const GridWidget()
      ),
    );
  }
}

// Future<int> _calculateWidth(XFile img) {
//   Completer<int> completer = Completer();
//   Image image = Image.file(File(img.path));
//   image.image.resolve(ImageConfiguration()).addListener(
//     ImageStreamListener(
//       (ImageInfo image, bool synchronousCall) {
//         var myImage = image.image;
//         int size = myImage.width;
//         completer.complete(size);
//       },
//     ),
//   );
//   return completer.future;
// }

class GridWidget extends StatefulWidget {
  const GridWidget({ Key? key }) : super(key: key);

  @override
  State<GridWidget> createState() => _GridWidgetState();
}

class _GridWidgetState extends State<GridWidget> {

  List<File> _imageFileList = [];

  int len = 0;

  set _imageFile(File value) {
      _imageFileList.add(value);
  }

  void _getFromGallery() async {
  
    XFile? pickedFile = await ImagePicker().pickImage(
            source: ImageSource.gallery,
            maxWidth: 5000,
            maxHeight: 5000,
          );
          setState(() {
          if (pickedFile!=null){
           _imageFile = File(pickedFile.path);
           len = len + 1;
          }
          });
  }

  void _getFromCamera() async {

    XFile? pickedFile = await ImagePicker().pickImage(
            source: ImageSource.camera,
            maxWidth: 5000,
            maxHeight: 5000,
          );
          setState(() {
          if (pickedFile!=null){
           _imageFile = File(pickedFile.path);
          //  _calculateWidth(pickedFile).then((s) => _imgwidth = s);
          //  _calculateWidth(pickedFile).then((s) => _imgheight = s);
           len = len + 1;
          }
          });
}

  @override
  Widget build(BuildContext context) {
    return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:[
            Container(
              padding: const EdgeInsets.all(10),
              height: 200.0,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  child: Text(
                    "Album 571",
                    style: const TextStyle(fontSize:32, fontWeight: FontWeight.bold)
                  ),
                ),
              ),
            ),
            _imageFileList!=null ?
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(5),
                width:500.0,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    // return Image.file(File(_imageFileList[index].path));
                  //   return Material(
                  //     child: InkWell(
                  //       onTap: () {
                  //         Navigator.push(
                  //           context,
                  //           MaterialPageRoute(
                  //             builder: (context) => ImageScreen(img: Image.file(File(_imageFileList[index].path))),
                  //           ),
                  //         );
                  //       },
                  //       child: Expanded (child:Image.file(File(_imageFileList[index].path)))
                  //     ),
                  // );
                  // return Container(
                  //     padding: const EdgeInsets.all(5),
                  //     child :ClipRRect(
                  //     borderRadius: BorderRadius.circular(5), // Image border
                  //     child: SizedBox.fromSize(
                  //       size: Size.fromRadius(5), // Image radius
                  //       child: Image.file(File(_imageFileList[index].path), fit: BoxFit.cover),
                  //     ),
                  //   )
                  // );
                  return GestureDetector(
                      onTap: () async {
                          var decodedImage = await decodeImageFromList(_imageFileList[index].readAsBytesSync());

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ImageScreen(img: Image.file(File(_imageFileList[index].path)), w: decodedImage.width, h: decodedImage.height),
                            ),
                          );
                      },
                        child: Container(
                        padding: const EdgeInsets.all(5),
                        child :ClipRRect(
                      
                        borderRadius: BorderRadius.circular(10), // Image border
                        child: SizedBox.fromSize(
                          // size: Size.fromRadius(5), // Image radius
                          child: Image.file(File(_imageFileList[index].path), fit: BoxFit.cover),
                        ),
                      )
                    )
                  );
                      
                  }, 
                  itemCount: _imageFileList.length,
                ),
              )
            ) : Expanded(child:Text("")),
            Container(
              padding: const EdgeInsets.all(20),
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child:Container(
                    height:75,
                    width:150,
                    padding: EdgeInsets.all(5),
                    child: ElevatedButton(  
                      onPressed: () {_getFromGallery();},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.photo_library_outlined,
                            size: 20,
                            color: Colors.blue,
                          ),
                          Text('Add from photo', style: TextStyle(fontSize: 13.0, color: Colors.blue,),),
                        ] 
                      ), 
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 228, 228, 228),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15), // <-- Radius
                        ),
                      ),
                    ),
                  ), 
                  ),
                  Expanded(
                    child:Container(
                    height:75,
                    width:150,
                    padding: EdgeInsets.all(5),
                    child: ElevatedButton(  
                      onPressed: () {_getFromCamera();},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Typicons.camera_outline,
                            // Icons.camera_outlined,
                            size: 20,
                            color: Colors.white,
                          ),
                          Text('Use Camera', style: TextStyle(fontSize: 13.0),),
                        ] 
                      ),   
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15), // <-- Radius
                        ),
                        ),
                    ),
                  ), 
                  ),
                  
                  // TextButton(
                  //   style: ButtonStyle(
                  //     foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                  //   ),
                  //   onPressed: () { 
                  //   _getFromCamera();
                  //   },
                  //   child: Text('Use Camera'),
                  // ),
                ],
              )
            )
          ],
        );
  }
}

class ImageScreen extends StatelessWidget {
  const ImageScreen({Key? key, required this.img, required this.w, required this.h}) : super(key: key);

  final Image img;
  final int w;
  final int h;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
        color: Colors.blue,
        ),
        backgroundColor: Colors.white,
        title: Text("Album 571", style: TextStyle( color: Colors.blue,)),
        centerTitle: false,
        leadingWidth:10,
      ),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:[
            Container(
              padding: const EdgeInsets.all(5),
              child: Expanded(child: img,)
          ),
          Column(
            children: 
              [
                Text('Image width: $w px'),
                Text('Image height: $h px'),
              ],
          )
        ]
      )
    );
  }
}