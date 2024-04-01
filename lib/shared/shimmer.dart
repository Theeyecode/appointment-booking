import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  Widget? widgetToDisplay;
  int? itemCount;

  ShimmerLoading({super.key, this.itemCount = 8}) {
    widgetToDisplay = _normaList();
  }

  ShimmerLoading.grid({super.key}) {
    widgetToDisplay = _grid();
  }

  // ShimmerLoading.billCategories() {
  //   widgetToDisplay = _bills();
  // }
  //
  // ShimmerLoading.billItems() {
  //   widgetToDisplay = _billsItems();
  // }
  //
  // ShimmerLoading.historyList() {
  //   widgetToDisplay = _historyList();
  // }

  Widget _bills() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 50, bottom: 8.0, left: 20, right: 20),
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.only(bottom: 10.0, top: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 2.0,
              height: 65.0,
              color: Colors.white,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.0),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  height: 65.0,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
      itemCount: 7,
    );
  }

  Widget _billsItems() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 40, bottom: 8.0, left: 20, right: 20),
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.only(bottom: 10.0, top: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 2.0,
              height: 40.0,
              color: Colors.white,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.0),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  height: 40.0,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
      itemCount: 7,
    );
  }

  Widget _normaList() {
    return ListView.builder(
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0, left: 20, right: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48.0,
              height: 48.0,
              color: Colors.white,
            ),
            const Padding(padding: EdgeInsets.symmetric(horizontal: 8.0)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Container(
                      width: double.infinity,
                      height: 8.0,
                      color: Colors.white,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Container(
                      width: double.infinity,
                      height: 8.0,
                      color: Colors.white,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Container(
                      width: 40.0,
                      height: 8.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      itemCount: itemCount ?? 8,
    );
  }

  Widget _grid() {
    return GridView.count(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      crossAxisCount: 3,
      childAspectRatio: 1.3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: List.generate(7, (index) {
        return Container(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(0),
              child: Center(
                  child: Text(
                "Item",
                textAlign: TextAlign.center,
              )), /*Image.asset(
              "images/placeholders/dstv.jpg",
              width: 70,
              height: 40,
              fit: BoxFit.contain,
            )*/
            ),
          ),
        );
      }),
    );
  }

  Widget _historyList() {
    return ListView.builder(
      itemBuilder: (_, __) => Padding(
        padding: const EdgeInsets.only(bottom: 8.0, left: 20, right: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipOval(
              child: Container(
                width: 48.0,
                height: 48.0,
                color: Colors.white,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Container(
                      width: double.infinity,
                      height: 8.0,
                      color: Colors.white,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Container(
                      width: double.infinity,
                      height: 8.0,
                      color: Colors.white,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Container(
                      width: 60.0,
                      height: 8.0,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      itemCount: 6,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade400,
      highlightColor: Colors.grey.shade100,
      child: widgetToDisplay!,
    );
  }
}
