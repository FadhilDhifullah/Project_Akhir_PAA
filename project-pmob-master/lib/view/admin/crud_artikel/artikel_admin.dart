import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trash_solver/viewmodel/tambahartikel_viewmodel.dart';
import 'package:trash_solver/utils/utils.dart';
import 'package:trash_solver/utils/routes/routes_names.dart';

class ArtikelAdmin extends StatefulWidget {
  const ArtikelAdmin({super.key});

  @override
  State<ArtikelAdmin> createState() => _ArtikelAdminState();
}

class _ArtikelAdminState extends State<ArtikelAdmin> {
  @override
  void initState() {
    super.initState();
    Provider.of<TambahartikelViewmodel>(context, listen: false).fetchDataFromApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        automaticallyImplyLeading: false,
        title: Text(
          'Artikel',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        color: Colors.lightGreenAccent[100],
        child: Column(
          children: [
            Expanded(
              child: Consumer<TambahartikelViewmodel>(
                builder: (context, viewModel, child) {
                  if (viewModel.articles.isEmpty) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return ListView.builder(
                      itemCount: viewModel.articles.length,
                      itemBuilder: (context, index) {
                        final article = viewModel.articles[index];
                        return ArtikelCard(
                          id: article['id'],
                          title: article['title'],
                          description: article['description'],
                          image: article['imageUrl'],
                        );
                      },
                    );
                  }
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, RouteNames.tambahArtikelAdmin);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: Text(
                'Tambah',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class ArtikelCard extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  final String image;

  ArtikelCard({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Card(
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.0),
                  topRight: Radius.circular(8.0),
                ),
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                  width: 30,
                  height: 100,
                ),
              ),
            ),
            ListTile(
              title: Text(title),
              subtitle: Text(
                description.length > 10
                    ? '${description.substring(0, 10)}...'
                    : description,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      RouteNames.editArtikelAdmin,
                      arguments: id,
                    );
                  },
                  child: Text(
                    'Edit',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                SizedBox(width: 8),
                TextButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Konfirmasi"),
                          content: Text("Apakah Anda yakin ingin menghapus item ini?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Batal"),
                            ),
                            TextButton(
                              onPressed: () {
                                // Hapus item dari view model
                                Provider.of<TambahartikelViewmodel>(
                                  context,
                                  listen: false,
                                ).deleteItem(id);

                                Utils.showSuccessSnackBar(
                                  Overlay.of(context),
                                  "Data berhasil Dihapus",
                                );
                                Navigator.pop(context);
                              },
                              child: Text("Hapus"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                SizedBox(width: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
