
import 'package:apptempesp32/pages/bloc_test_pag.dart';
import 'package:apptempesp32/pages/menus/controller_pages.dart';
import 'package:apptempesp32/pages/pag_Cert.dart';
import 'package:flutter/material.dart';


class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    
    final PageIndex _pageIndex = PageIndex(); //Simple Pag Controller

    return AppBar(
      backgroundColor: Colors.grey.shade400,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        }, //TODO Perfil icon superior esquedo
        icon: const Icon(
          Icons.account_circle_rounded,
          size: 30,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PagCert(),//const PagGeneric(pagText: 'Pag 5'),
              ),
            );
          }, //TODO Menu icon superior direito
          icon: const Icon(
            Icons.menu,
            size: 30,
          ),
        ),
      ],
    );
  }
}
