import 'package:flutter/material.dart';

// import '../../locator.dart';
// import '../shared/confirm_action_dialog.dart';
// import './list_all_zips_view.dart';

class SettingDrawer extends StatefulWidget {
  const SettingDrawer({super.key});

  @override
  State<SettingDrawer> createState() => _SettingDrawerState();
}

class _SettingDrawerState extends State<SettingDrawer> {
  // final SettingViewModel _settingViewModel = locator<SettingViewModel>();
  bool isLoading = false;


  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 5,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: const Text(
              '林田記',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: isLoading
                ? const CircularProgressIndicator()
                : const Icon(Icons.account_circle),
            title: const Text('匯出所有檔案'),
            onTap: (){},
            // onTap: isLoading ? null : ()  =>  Navigator.of(context).popAndPushNamed(ListAllZipsView.routeName),
          ),
          ListTile(
            onTap: () async {
              // final doLogout = await confirmActionDialog(
              //   context,
              //   title: '確認登出',
              // );
              // if (doLogout == true) {
              //   // await _settingViewModel.logout();
              // }
            },
            leading: const Icon(Icons.message),
            title: const Text('登出'),
          ),
        ],
      ),
    );
  }
}
