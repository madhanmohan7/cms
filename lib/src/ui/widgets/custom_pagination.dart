import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/colors/colors.dart';

class CustomPagination extends StatefulWidget {
  final int totalItems;
  final int rowsPerPage;
  final ValueChanged<int> onPageChanged;

  CustomPagination({
    required this.totalItems,
    required this.rowsPerPage,
    required this.onPageChanged,
  });

  @override
  _CustomPaginationState createState() => _CustomPaginationState();
}

class _CustomPaginationState extends State<CustomPagination> {
  int currentPage = 1;

  @override
  Widget build(BuildContext context) {
    int totalPages = (widget.totalItems / widget.rowsPerPage).ceil();

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextButton(
              onPressed: () {
                if (currentPage != 1) {
                  setState(() {
                    currentPage = 1;
                  });
                  widget.onPageChanged(currentPage);
                }
              },
              child: Row(
                children: [
                  const Icon(CupertinoIcons.arrow_left_to_line, color: oBlack, size: 16),
                  const SizedBox(width: 5,),
                  Text("Go to Page 1", style: GoogleFonts.poppins(fontSize: 13, color: oBlack)),
                ],
              )
          ),
          const Spacer(),
          TextButton(
            onPressed: currentPage > 1
                ? () {
              setState(() {
                currentPage -= 1;
              });
              widget.onPageChanged(currentPage);
            }
                : null,
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(width: 1, color: oBlack)
                ),
              ),
              minimumSize: MaterialStateProperty.all(const Size(45, 45)),
            ),
            child: const Icon(CupertinoIcons.arrow_left, color: oBlack, size: 16),
          ),
          const SizedBox(width: 10),
          TextButton(
            onPressed: currentPage < totalPages
                ? () {
              setState(() {
                currentPage += 1;
              });
              widget.onPageChanged(currentPage);
            }
                : null,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(oBlack),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              fixedSize: MaterialStateProperty.all(const Size(115, 40)),
            ),
            child: Row(
              children: [
                Text('Next Page', style: GoogleFonts.poppins(fontSize: 13, color: oWhite)),
                const SizedBox(width: 5),
                const Icon(CupertinoIcons.arrow_right, color: oWhite, size: 16),
              ],
            ),
          ),
          //const SizedBox(width: 20),
          const Spacer(),
          Text('Page $currentPage of $totalPages',
            style: GoogleFonts.poppins(fontSize: 13, color: oBlack.withOpacity(0.8)),
          ),
        ],
      ),
    );
  }
}
