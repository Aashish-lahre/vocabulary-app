// import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
// import 'package:flutter/material.dart';
//
// import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:flutter_improve_vocabulary/word/cubit/word_cubit.dart';
// import 'package:flutter_improve_vocabulary/word/widgets/word_failure.dart';
//
// import '../../core/network/internet_bloc.dart';
// import '../../features/search/presentation/screens/search_page.dart';
// import '../../features/word/bloc/word_bloc.dart';
// import '../widgets/word_initial.dart';
// import '../widgets/word_loading.dart';
// import '../widgets/word_success.dart';
//
// class WordPage extends StatelessWidget {
//   const WordPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: false,
//       appBar: AppBar(title: Text('Word Page'),),
//       body: BlocListener<InternetBloc, InternetState>(
//         listener: (context, state) {
//
//
//           final snackBar = SnackBar(
//             /// need to set following properties for best effect of awesome_snackbar_content
//             elevation: 0,
//             behavior: SnackBarBehavior.floating,
//             backgroundColor: Colors.transparent,
//             content: AwesomeSnackbarContent(
//               title: state.status ? "Hooray!" :'On Snap!',
//               message:
//               state.status ? "We are back Online!" : 'No Internet Connection, try again!',
//
//               /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
//               contentType: state.status ? ContentType.success : ContentType.failure,
//
//             ),
//           );
//           ScaffoldMessenger.of(context).showSnackBar(snackBar);
//         },
//         child: BlocBuilder<WordBloc, WordState>(
//             builder: (context, state) {
//               if(WordSearchLoadSuccess == state.runtimeType) {
//                 return ListView.builder(
//                     itemCount: (state as WordSearchLoadSuccess).words.length,
//                     itemBuilder: (_, index) {
//                       return Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           color: Colors.deepPurpleAccent[100],
//                           child: Column(
//                             children: [
//                               Text(state.words[index].word),
//                               SizedBox(height: 30,),
//                               Text(state.words[index].meanings.first.definitions.first.definition),
//                             ],
//                           ),
//                         ),
//                       );
//                     });
//               } else {
//                 return Center(child: Text('error : ${state.toString()}'),);
//               }
//
//         }),
//       ),
//       floatingActionButton: FloatingActionButton(onPressed: () async {
//         // final wordQueryReceivedFromSearchPage = await Navigator.of(context)
//         //     .push(SearchPage.route());
//         // if (!context.mounted) return;
//         // await context.read<WordCubit>().getWord(
//         //     wordQueryReceivedFromSearchPage as String);
//         // print('we got the word');
//       },
//
//         child: Icon(Icons.search),),
//     );
//   }
// }