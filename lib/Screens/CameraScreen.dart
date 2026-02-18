import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wp_app/Services/AuthService.dart';
import 'package:wp_app/colors.dart';

///
/// Schermata per la gestione della fotocamera, scatto e upload dell'immagine
///
class CameraScreen extends StatefulWidget {
  final url;
  const CameraScreen({super.key, required this.url});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}


class _CameraScreenState extends State<CameraScreen> {
  File? _capturedImage;
  bool _isUploading = false;
  final ImagePicker _picker = ImagePicker();

  ///
  /// Funzione per scattare una foto usando la fotocamera del dispositivo
  ///
  Future<void> _takePhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 90,
    );
    if (photo != null) {
      setState(() => _capturedImage = File(photo.path));
    }
  }

  ///
  /// Funzione per accettare l'immagine scattata e inviarla al server tramite AuthService
  ///
  Future<void> _acceptImage() async {
    if (_capturedImage == null) return;

    setState(() => _isUploading = true);

    final result = await AuthService().addImage(_capturedImage!.path);
    print("status caricamento immagine: $result");
    if (!mounted) return;
    setState(() => _isUploading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result),
        backgroundColor: result.contains('successo') ? Colors.green : Colors.red,
      ),
    );

    if (result.contains('successo')) {
      Navigator.pushNamed(context, '/container', arguments: {'url': widget.url});
    }
  }

  void _retakePhoto() {
    setState(() => _capturedImage = null);
    _takePhoto();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background_color,
      appBar: AppBar(
        backgroundColor: background_color,
        title: Text(
          _capturedImage == null ? 'Fotocamera' : 'Anteprima',
          style: const TextStyle(color: primary_color),
        ),
      ),
      body: _capturedImage == null ? _buildCameraPrompt() : _buildPreview(),
    );
  }

  ///
  /// Widget che mostra l'icona della fotocamera e il pulsante per scattare una foto quando non è stata ancora catturata un'immagine
  ///
  Widget _buildCameraPrompt() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.camera_alt, size: 80, color: primary_color),
          const SizedBox(height: 24),
          const Text('Scatta una foto', style: TextStyle(color: Colors.white70, fontSize: 18)),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: _takePhoto,
            icon: const Icon(Icons.camera_alt, color: terziary_color,),
            label: const Text('Apri fotocamera', style: TextStyle(
              color: primary_color,
              fontSize: 16,
            ),),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
          ),
        ],
      ),
    );
  }

  ///
  /// Widget che mostra l'anteprima dell'immagine catturata e i pulsanti per accettare o rifare la foto
  ///
  Widget _buildPreview() {
    return Column(
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(_capturedImage!, fit: BoxFit.cover),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  // Disabilita i bottoni durante l'upload
                  onPressed: _isUploading ? null : _retakePhoto,
                  icon: const Icon(Icons.refresh, color: primary_color, size: 25,),
                  label: const Text('', style: TextStyle(color: Colors.white)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Colors.white54),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _isUploading ? null : _acceptImage,
                  // Mostra spinner durante l'upload
                  icon: _isUploading
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                      : const Icon(Icons.check),
                  label: Text(_isUploading ? 'Caricamento...' : 'Accetta'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}