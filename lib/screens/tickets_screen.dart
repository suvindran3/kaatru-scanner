import 'package:device_scanner/models/ticket_model.dart';
import 'package:device_scanner/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import '../network/database.dart';

class TicketsScreen extends StatelessWidget {
  const TicketsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<TicketModel>>(
        future: Database.getTickets(),
        builder: (context, future) {
          if (future.hasData) {
            if (future.data!.isEmpty) {
              return Center(
                child: Text(
                  'No active tickets'.toUpperCase(),
                  style: GoogleFonts.outfit(
                      color: Colors.grey, fontWeight: FontWeight.bold),
                ),
              );
            } else {
              return ListView(
                padding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: MediaQuery.of(context).padding.top + 10),
                children: List.generate(
                  future.data!.length,
                  (index) => _TicketCard(
                    ticket: future.data!.elementAt(index),
                  ),
                ),
              );
            }
          } else {
            return const Center(
              child: SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation(Colors.brown),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  final TicketModel ticket;

  const _TicketCard({
    Key? key,
    required this.ticket,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 115,
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: kElevationToShadow[3],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircleAvatar(
                    radius: 10,
                    backgroundColor: Color(0xffEAEFF3),
                    child: Icon(
                      Icons.person,
                      color: Colors.grey,
                      size: 15,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    'User ID: ${ticket.userID}',
                    style: GoogleFonts.outfit(
                      color: Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: ticket.status == 'open'
                      ? Colors.red.shade100
                      : ticket.status == 'assigned'
                          ? Colors.orange.shade100
                          : Colors.green.shade100,
                  border: Border.all(
                      color: ticket.status == 'open'
                          ? Colors.red
                          : ticket.status == 'assigned'
                              ? Colors.orange
                              : Colors.green),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  ticket.status.toUpperCase(),
                  style: GoogleFonts.outfit(
                      color: ticket.status == 'open'
                          ? Colors.red
                          : ticket.status == 'assigned'
                              ? Colors.orange
                              : Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 10),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10),
            child: Text(
              'Issue with device ${ticket.deviceID}',
              style:
                  GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
          const SizedBox(
            height: 2,
            child: Divider(
              color: Colors.grey,
              thickness: 0.1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 7.0),
            child: Row(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.confirmation_number_rounded,
                      size: 15,
                      color: Colors.black54,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      '#${ticket.id}',
                      style: GoogleFonts.outfit(fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 15,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 7.0),
                      child: Text(
                        '.',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.timer,
                      size: 15,
                      color: Colors.black54,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      ticket.timestamp.split(',')[0],
                      style: GoogleFonts.outfit(fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(
                  width: 15,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 7.0),
                      child: Text(
                        '.',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 15,
                      color: Colors.black54,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      ticket.timestamp.split(',')[1],
                      style: GoogleFonts.outfit(fontSize: 11),
                    ),
                  ],
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MapScreen(
                              devicePosition: LatLng(ticket.lat, ticket.lng),
                            ),
                          ),
                        ),
                        child: const CircleAvatar(
                          radius: 13,
                          backgroundColor: Colors.brown,
                          child: Icon(
                            Icons.location_on,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
