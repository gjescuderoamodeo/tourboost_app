import 'package:flutter/material.dart';
import 'package:tourboost_app/theme/app_theme.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomCardType extends StatelessWidget {
  //propiedades
  final String imageUrl;
  final String mensaje;
  final String nombre;

  const CustomCardType(
      {super.key,
      required this.imageUrl,
      required this.mensaje,
      required this.nombre});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      //para bordes aún más redondeados
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      shadowColor: AppTheme.primary.withOpacity(0.6),
      elevation: 20,
      child: Column(children: [
        //NetworkImage mandar imagen por url
        //Image(
        //    image: NetworkImage(
        //        'https://th.bing.com/th/id/OIP.YwUr61ty6Ne_Ijl-Kn-9sQHaFH?pid=ImgDet&rs=1'))
        FadeInImage(
          image: NetworkImage(imageUrl),
          placeholder: const AssetImage('assets/jar-loading.gif'),
          height: 230,
        ),
        Container(
            alignment: AlignmentDirectional.centerEnd,
            padding: const EdgeInsets.only(right: 20, top: 10, bottom: 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(nombre,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(mensaje, style: const TextStyle(fontSize: 15)),
                ),
                const SizedBox(
                  height: 10,
                ),
                //botón de como llegar
                ElevatedButton(
                  onPressed: () async {
                    final url =
                        'https://www.google.com/maps/search/?api=1&query=$nombre';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'No se pudo abrir el mapa.';
                    }
                  },
                  child: Column(
                    children: const [
                      Text('Como llegar'),
                      Icon(Icons.directions)
                    ],
                  ),
                ),
              ],
            ))
      ]),
    );
  }
}
