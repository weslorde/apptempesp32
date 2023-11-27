import 'package:apptempesp32/api/data_storege.dart';
import 'package:apptempesp32/pages/menus/controller_pages.dart';
import 'package:apptempesp32/pages/cert_page.dart';
import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    final AllData data = AllData();
    final pageController = PageIndex();

    return AppBar(
      backgroundColor: Colors.grey.shade400,
      leading: IconButton(
        onPressed: () {
          print("perfil button");
        }, //TODO Perfil icon superior esquedo
        icon: const Icon(
          Icons.account_circle_rounded,
          size: 30,
        ),
      ),
      actions: [
        PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(value: 'Cert', child: Text('Certificado')),
            const PopupMenuItem(value: 'Config', child: Text('Configuração')),
            const PopupMenuItem(value: 'data3', child: Text('data3')),
          ],
          child: const Icon(
            Icons.menu,
            size: 30,
            color: Colors.black,
          ),
          onSelected: (String newValue) {
            switch (newValue) {
              case 'Cert':
                if (pageController.getIndex != 3) {
                  pageController.setIndex = 3;
                }
            }
          },
        ),
      ],
    );
  }
}
