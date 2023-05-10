import 'package:flutter/material.dart';
import 'package:tourboost_app/theme/app_theme.dart';

class CustomCardType extends StatelessWidget {
  //propiedades
  final String imageUrl;
  final String mensaje;

  const CustomCardType(
      {super.key, required this.imageUrl, required this.mensaje});

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
            child: Text(mensaje))
      ]),
    );
  }
}
