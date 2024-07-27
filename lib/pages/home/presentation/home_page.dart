import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wiet_assignment/pages/home/domain/home_cubit.dart';
import 'package:wiet_assignment/pages/home/domain/home_state.dart';
import 'package:wiet_assignment/pages/home/presentation/widgets/cat_id_dialog.dart';
import 'package:wiet_assignment/pages/home/presentation/widgets/tier_wheel_painter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    BlocProvider.of<HomeCubit>(context).fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Cat App'),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'Home',
              )
            ],
          ),
        ),
        body: SafeArea(child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return state.cats.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 2,
                                      mainAxisSpacing: 2),
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: state.cats.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                    onTap: () {
                                      showAdaptiveDialog(
                                          context: context,
                                          builder: (context) {
                                            Future.delayed(
                                                const Duration(seconds: 1), () {
                                              Navigator.of(context).pop(true);
                                            });
                                            return CatIdDialog(
                                                catId: state.cats[index].id);
                                          });
                                    },
                                    child: CachedNetworkImage(
                                      imageUrl: state.cats[index].url,
                                      progressIndicatorBuilder:
                                          (context, url, downloadProgress) =>
                                              Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: CircularProgressIndicator(
                                          value: downloadProgress.progress,
                                          strokeCap: StrokeCap.butt,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                      fit: BoxFit.cover,
                                    ));
                              },
                            ),
                          ),
                          const SizedBox(height: 100),
                          Flexible(
                            fit: FlexFit.loose,
                            child: SizedBox(
                              height: MediaQuery.of(context).size.width * 0.80,
                              width: MediaQuery.of(context).size.width * 0.80,
                              child: CustomPaint(
                                isComplex: true,
                                painter: TierWheelPainter(state),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
          },
        )),
      ),
    );
  }
}
