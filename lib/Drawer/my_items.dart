import 'package:flutter/material.dart';
import 'package:vendor/Components/drawer.dart';
import 'package:vendor/Locale/locales.dart';
import 'package:vendor/Pages/Other/adminproductpage.dart';
import 'package:vendor/Pages/Other/storeproductpage.dart';
import 'package:vendor/Routes/routes.dart';

class MyItemsPage extends StatefulWidget {
  const MyItemsPage({super.key});

  @override
  State<MyItemsPage> createState() => _MyItemsPageState();
}

class _MyItemsPageState extends State<MyItemsPage> with SingleTickerProviderStateMixin {
  TabController? tabController;
  int lastIndex = -1;
  int currentTabIndex = 0;
  @override
  void initState() {
    tabController = TabController(length: 2, vsync: this);
     tabController!.addListener(_tabControllerListener);
    super.initState();
  }

  void _tabControllerListener() {
    setState(() {
      currentTabIndex = tabController!.index;
    });
  }

  @override
  void dispose() {
    tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: buildDrawer(context),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          title: Text(
            locale.myItems!.toUpperCase(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          centerTitle: true,
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            TabBar(
              tabs: [
                Tab(text: locale.storepheading!),
                Tab(text: locale.adminpheading!),
              ],
              isScrollable: false,
              controller: tabController,
              indicatorWeight: 1,
              indicatorColor: Colors.transparent,
              labelPadding: const EdgeInsets.all(0),
              onTap: (int index) {
                setState(() {
                  currentTabIndex = index;
                });
              },
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: const [
                  MyStoreProduct(),
                  MyAdminProduct(),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
          size: 32,
        ),
        onPressed: () {
          setState(() {
            lastIndex = tabController!.index;
            tabController!.index = (lastIndex == 0) ? 1 : 0;
          });
          Navigator.pushNamed(context, PageRoutes.addItem).then((value) {
            setState(() {
              tabController!.index = lastIndex;
            });
          }).catchError((e) {
            debugPrint(e);
          });
        },
      ),
    );
  }
}
