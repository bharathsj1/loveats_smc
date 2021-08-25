import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:potbelly/routes/router.dart';
import 'package:potbelly/routes/router.gr.dart';
import 'package:potbelly/values/values.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:toast/toast.dart';

class QrScanner extends StatefulWidget {
   var data;
  QrScanner({@required this.data});
  @override
  State<StatefulWidget> createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  Barcode result;
  QRViewController controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool cameraon=true;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    }
    controller.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded( child: _buildQrView(context)),
          // Expanded(
          //   flex: 0,
          //   child: FittedBox(
          //     fit: BoxFit.contain,
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: <Widget>[
          //         if (result != null)
          //           Text(
          //               'Barcode Type: ${describeEnum(result.format)}   Data: ${result.code}')
          //         else
          //           Text('Scan a code'),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //           children: <Widget>[
          //             Container(
          //               margin: EdgeInsets.all(8),
          //               child: ElevatedButton(
          //                   onPressed: () async {
          //                     await controller?.toggleFlash();
          //                     setState(() {});
          //                   },
          //                   child: FutureBuilder(
          //                     future: controller?.getFlashStatus(),
          //                     builder: (context, snapshot) {
          //                       return Text(
          //                         'Flash: ${snapshot.data}',
          //                         style: TextStyle(color: Colors.black),
          //                       );
          //                     },
          //                   )),
          //             ),
          //             Container(
          //               margin: EdgeInsets.all(8),
          //               child: ElevatedButton(
          //                   onPressed: () async {
          //                     await controller?.flipCamera();
          //                     setState(() {});
          //                   },
          //                   child: FutureBuilder(
          //                     future: controller?.getCameraInfo(),
          //                     builder: (context, snapshot) {
          //                       if (snapshot.data != null) {
          //                         return Text(
          //                             'Camera facing ${describeEnum(snapshot.data)}',
          //                             style: TextStyle(color: Colors.black));
          //                       } else {
          //                         return Text('loading',
          //                             style: TextStyle(color: Colors.black));
          //                       }
          //                     },
          //                   )),
          //             )
          //           ],
          //         ),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //           children: <Widget>[
          //             Container(
          //               margin: EdgeInsets.all(8),
          //               child: ElevatedButton(
          //                 onPressed: () async {
          //                   await controller?.pauseCamera();
          //                 },
          //                 child: Text('pause',
          //                     style:
          //                         TextStyle(fontSize: 20, color: Colors.black)),
          //               ),
          //             ),
          //             Container(
          //               margin: EdgeInsets.all(8),
          //               child: ElevatedButton(
          //                 onPressed: () async {
          //                   await controller?.resumeCamera();
          //                 },
          //                 child: Text('resume',
          //                     style:
          //                         TextStyle(fontSize: 20, color: Colors.black)),
          //               ),
          //             )
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // )
        
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 250.0
        : 350.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return Stack(
      children: [
        QRView(
          key: qrKey,
          onQRViewCreated: _onQRViewCreated,
          overlay: QrScannerOverlayShape(
              borderColor: AppColors.secondaryElement,
              borderRadius: 10,
              borderLength: 34,
              borderWidth: 6,
              cutOutSize: scanArea),
          onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
        ),
       controller !=null? Positioned(
            bottom: 15,
            left: 15,
            right: 15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                    onTap: () async {
                      await controller?.toggleFlash();
                      setState(() {});
                    },
                    child: FutureBuilder(
                      future: controller?.getFlashStatus(),
                      builder: (context, snapshot) {
                        return Icon(
                            snapshot.data ? Icons.flash_on : Icons.flash_off,
                            color: AppColors.secondaryElement);
                      },
                    )),

                // SizedBox(width: 10,)
              cameraon? ElevatedButton(
                          onPressed: () async {
                            await controller?.pauseCamera();
                            cameraon=false;
                            setState(() {
                              
                            });
                          },
                          child: Icon(
                  Icons.pause,
                  color: AppColors.secondaryElement,
                  size: 26,
                ),
                        ): ElevatedButton(
                          onPressed: () async {
                            await controller?.resumeCamera();
                            cameraon=true;
                            setState(() {
                              
                            });
                          },
                          child: Icon(
                  Icons.play_arrow,
                  color: AppColors.secondaryElement,
                  size: 26,
                ),
                        ),
                      
               
                InkWell(
                    onTap: () async {
                      await controller?.flipCamera();
                      setState(() {});
                    },
                    child: FutureBuilder(
                      future: controller?.getCameraInfo(),
                      builder: (context, snapshot) {
                        if (snapshot.data != null) {
                          return Icon(Icons.cameraswitch,
                              color: AppColors.secondaryElement);
                        } else {
                          return Text('loading',
                              style: TextStyle(color: Colors.black));
                        }
                      },
                    )),
              ],
            )):Container()
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      controller.pauseCamera();
      cameraon=false;
      // setState(() async {
        result = scanData;
        print(scanData.code);
        print(scanData.code.substring(scanData.code.length-17));
        if(scanData.code.substring(scanData.code.length-17) == '/com.smc.loveats/'){
          print(scanData.code.substring(0,scanData.code.length-17));
          var id= scanData.code.substring(0,scanData.code.length-17);
           var data= await widget.data
                        .where((product) => product.id.toString() == id).toList();
             if(data.length>0){
           
            Navigator.pushReplacementNamed(
                          context,
                          AppRouter.restaurantDetailsScreen,
                          arguments: RestaurantDetails(
                              imagePath: data[0].restImage,
                              restaurantName: data[0].restName,
                              restaurantAddress: data[0].restAddress +
                                  data[0].restCity +
                                  ' ' +
                                  data[0].restCountry,
                              rating: '0.0',
                              category: data[0].restType,
                              distance: '0 Km',
                              data: data[0]),
                        );
                                       
             }
             else{
                Toast.show('Restaurant not found', context, duration: 3);
             }
        }
        else{
           Toast.show('Wrong Qr, Please Scan right QR of Restaurant', context, duration: 3);
        }
      });
    // });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
