import 'dart:convert';

import 'package:currency_rate_api/api_response.dart';
import 'package:currency_rate_api/currency_rate.dart';
import 'package:currency_rate_api/main_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  MainProvider? _mainP;

  @override
  void initState() {
    super.initState();
    _mainP = Provider.of<MainProvider>(context, listen: false);
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    if (mounted)
      setState(() {
        _mainP?.getCurrencyRate();
      });
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadData()
    if (mounted)
      setState(() {
        _mainP?.getCurrencyRate();
      });
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8),
      appBar: AppBar(
        actions: [
          IconButton(
              color: Colors.black,
              onPressed: () {
                setState(() {
                  _mainP?.getCurrencyRate();
                });
              },
              icon: Icon(Icons.refresh))
        ],
        elevation: 0,
        backgroundColor: Color(0xFFF8F8F8),
        title: Text(
          "Valyuta Kurslari",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        color: Color(0xFFF8F8F8),
        child: FutureBuilder(
          future: _mainP?.getCurrencyRate(),
          builder: (BuildContext context, AsyncSnapshot<ApiResponse> snapshot) {
            if (snapshot.data?.status == Status.LOADING) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data?.status == Status.SUCCESS) {
              return SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: true,
                  header: ClassicHeader(),
                  footer: CustomFooter(
                    builder: (BuildContext context, LoadStatus? mode) {
                      return Container();
                    },
                  ),
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  child: ListView.builder(
                      itemCount: snapshot.data?.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          padding: EdgeInsets.all(16),
                          margin: EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.transparent, spreadRadius: 3),
                            ],
                          ),
                          height: 120,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 26,
                                    height: 20,
                                    child: Image.asset(
                                      "assets/flags/${snapshot.data?.data[index].code}.png",
                                    ),
                                  ),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    snapshot.data?.data[index].code ?? "-",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                  Text(
                                    snapshot.data?.data[index].title ?? "-",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "MB kursi",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(
                                        snapshot.data?.data[index].cbPrice ??
                                            "-",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "Sotib olish",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(
                                        snapshot.data?.data[index].buyPrice ??
                                            "-",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "Sotish",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      Text(
                                        snapshot.data?.data[index].cellPrise ??
                                            "-",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }));
            }
            if (snapshot.data?.status == Status.LOADING) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data?.status == Status.ERROR) {
              return errorScreen(snapshot.data?.massage);
            }
            return Center(
              child: Text(
                snapshot.data?.massage ?? "Error",
                style: TextStyle(fontSize: 24),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget errorScreen(String? errorMsg) {
    return SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: ClassicHeader(),
    footer: CustomFooter(
    builder: (BuildContext context, LoadStatus? mode) {
    return Container();
    },
    ),
    controller: _refreshController,
    onRefresh: _onRefresh,
    onLoading: _onLoading,
    child:Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/offline/offline.gif"),
          Text("Internet bilan aloqa yo'q", style: TextStyle(fontSize: 24)),
          IconButton(
              onPressed: () {
                setState(() {
                  _mainP?.getCurrencyRate();
                });
              },
              icon: Icon(Icons.refresh))
        ],
      ),
    ));
  }
}
