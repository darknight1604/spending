part of './spending_listing_screen.dart';

class SpendingItem extends StatelessWidget {
  final Spending spending;
  const SpendingItem({
    super.key,
    required this.spending,
  });

  @override
  Widget build(BuildContext context) {
    var noSymbolInUSFormat = new NumberFormat('#,##0', 'en_US');

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          GetIt.I.get<SpendingRoute>().routeName,
          arguments: spending,
        ).then((value) {
          if (value == null) return;
          BlocProvider.of<SpendingListingBloc>(context)
              .add(FetchSpendingListingEvent());
        });
      },
      child: Container(
        padding: EdgeInsets.all(Constants.padding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Constants.radius),
          border: Border.all(color: Constants.borderColor),
          boxShadow: Constants.shadow,
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.attach_money_outlined,
                  size: Constants.iconSize,
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Text(
                    noSymbolInUSFormat.format(spending.cost ?? 0),
                    style: TextThemeUtil.instance.titleMedium,
                  ),
                ),
                InkWell(
                  onTap: () => _onTapDelete(context),
                  child: Icon(
                    Icons.delete_outline_outlined,
                    size: Constants.iconSize,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: Constants.padding,
            ),
            Row(
              children: [
                Icon(
                  Icons.category_outlined,
                  size: Constants.iconSize,
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  spending.categoryName ?? Constants.empty,
                  style: TextThemeUtil.instance.titleMedium,
                ),
              ],
            ),
            SizedBox(
              height: Constants.padding,
            ),
            if (spending.categoryId == Constants.otherCategoryId) ...[
              Row(
                children: [
                  SizedBox(
                    width: Constants.iconSize,
                  ),
                  Icon(
                    Icons.subdirectory_arrow_right_outlined,
                    size: Constants.iconSize,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    spending.otherCategory ?? Constants.empty,
                    style: TextThemeUtil.instance.titleMedium,
                  ),
                ],
              ),
              SizedBox(
                height: Constants.padding,
              ),
            ],
            Row(
              children: [
                Icon(
                  Icons.date_range_outlined,
                  size: Constants.iconSize,
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  spending.createdDate?.formatHHMMSSDDMMYYYY() ??
                      Constants.empty,
                  style: TextThemeUtil.instance.titleMedium,
                ),
              ],
            ),
            SizedBox(
              height: Constants.padding,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.event_note_outlined,
                  size: Constants.iconSize,
                  color: Theme.of(context).primaryColor,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  StringUtil.isNotNullOrEmpty(spending.note)
                      ? spending.note.toString()
                      : Constants.empty,
                  style: TextThemeUtil.instance.titleMedium,
                  maxLines: Constants.maxLines,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _onTapDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (contextBuilder) {
        return AlertDialog(
          title: Text(
            tr(LocaleKeys.common_confirm),
            style: TextThemeUtil.instance.titleMedium?.semiBold,
          ),
          content: Text(
            tr(LocaleKeys.common_areYouSureToDelete),
            style: TextThemeUtil.instance.bodyMedium?.regular,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                tr(LocaleKeys.common_cancel),
                style: TextThemeUtil.instance.bodyMedium?.regular,
              ),
            ),
            TextButton(
              onPressed: () {
                BlocProvider.of<SpendingListingBloc>(context).add(
                  DeleteSpendingListingEvent(spending),
                );
                Navigator.pop(context);
              },
              child: Text(
                tr(LocaleKeys.common_confirm),
                style: TextThemeUtil.instance.bodyMedium?.semiBold.copyWith(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
