import 'package:flutter/material.dart';
import 'package:cms_web/features/clientapp/models/client_invoice.dart';
import 'package:transparent_image/transparent_image.dart';

class ClientInvoiceItem extends StatelessWidget {
  const ClientInvoiceItem(
      {super.key,
      required this.clientInvoice,
      required this.onSelectClientInvoice});

  final ClientInvoice clientInvoice;
  final Function(ClientInvoice clientInvoice) onSelectClientInvoice;

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.hardEdge,
        elevation: 2,
        child: InkWell(
            onTap: () {
              onSelectClientInvoice(clientInvoice);
            },
            child: Stack(children: [
              Hero(
                tag: clientInvoice.invoiceId,
                child: FadeInImage(
                    placeholder: MemoryImage(kTransparentImage),
                    image: NetworkImage(clientInvoice.invoiceUrl!),
                    fit: BoxFit.cover,
                    height: 200,
                    width: double.infinity),
              ),
              Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                      color: Colors.black54,
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 44),
                      child: Column(children: [
                        Text(clientInvoice.invoiceNumber,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                        const SizedBox(height: 12),
                      ])))
            ])));
  }
}
