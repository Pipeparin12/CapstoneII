import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class TryOnScreen extends StatefulWidget {
  const TryOnScreen({super.key});

  @override
  State<TryOnScreen> createState() => _TryOnScreenState();
}

class _TryOnScreenState extends State<TryOnScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Try on virtual clothes'),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.black54,
        child: SizedBox(
          height: double.maxFinite,
          child: ModelViewer(
            src: '\\assets\\3D_models\\Men_S.glb',
            autoPlay: true,
            autoRotate: false,
            cameraControls: true,
          ),
        ),
      ),
    );
  }
}
