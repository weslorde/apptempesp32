import 'package:apptempesp32/api/data_storege.dart';
import 'package:apptempesp32/api/hex_to_colors.dart';
import 'package:apptempesp32/pages/menus/controller_pages.dart';
import 'package:apptempesp32/pages/cert_page.dart';
import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(60);
  

  @override
  Widget build(BuildContext context) {
    final AllData _data = AllData();
    final PageIndex pageController = PageIndex();

    return AppBar(
      backgroundColor: _data.darkMode ? HexColor.fromHex("#fafaff") : HexColor.fromHex('#101010'),
      surfaceTintColor: _data.darkMode ? HexColor.fromHex("#fafaff") : HexColor.fromHex('#101010'),
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
                if (pageController.getIndex != 7) {
                  pageController.setIndex = 7;
                }
            }
          },
        ),
      ],
    );
  }
}


/*



 */