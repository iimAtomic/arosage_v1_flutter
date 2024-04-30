import 'package:flutter/material.dart';
import 'package:arosagev1_flutter/views/plantes_feed_page.dart';

class CustomDialog extends StatelessWidget {
  final Future<List<Commentaire>> futureConseils;
  final TextEditingController commentController;
  final GlobalKey<FormState> formKey;
  final VoidCallback sendButtonMethod;

  const CustomDialog({super.key, 
    required this.futureConseils,
    required this.commentController,
    required this.formKey,
    required this.sendButtonMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Affichage des commentaires existants
          Expanded(
            child: FutureBuilder<List<Commentaire>>(
              future: futureConseils,
              builder: (context, snapshot) {
               if (snapshot.connectionState ==
                                          ConnectionState.waiting ||
                                      snapshot.connectionState ==
                                          ConnectionState.none) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text(
                                        'Erreur: ${snapshot.error.toString()}');
                                  } else {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (context, index) {
                                        var commentaire =
                                            snapshot.data![index];
                                        return ListTile(
                                          title: Text(commentaire.pseudo),
                                          subtitle:Text(commentaire.conseil),
                                        );
                                      },
                                    );
                                  }
              },
            ),
          ),
          // Champ de texte pour ajouter un nouveau commentaire
          CommentBox(
            sendButtonMethod: sendButtonMethod,
            formKey: formKey,
            commentController: commentController,
          ),
        ],
      ),
    );
  }
}
