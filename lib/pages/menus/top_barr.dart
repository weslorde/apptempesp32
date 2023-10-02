import 'package:apptempesp32/pages/pag_test.dart';
import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.grey.shade400,
      leading: IconButton(
        onPressed: () { Navigator.pop(context);}, //TODO Perfil icon superior esquedo
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
                  builder: (context) => const PagGeneric(
                        pagText: 'Pag 5',
                      )),
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
