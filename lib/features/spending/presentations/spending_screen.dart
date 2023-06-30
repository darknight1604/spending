import 'package:dani/core/applications/loading/loading_bloc.dart';
import 'package:dani/core/constants.dart';
import 'package:dani/core/utils/extensions/text_style_extension.dart';
import 'package:dani/core/utils/text_theme_util.dart';
import 'package:dani/core/widgets/base_stateful.dart';
import 'package:dani/core/widgets/input_date_picker.dart';
import 'package:dani/features/spending/businesses/models/spending_category.dart';
import 'package:dani/gen/locale_keys.g.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/utils/my_snackbar.dart';
import '../../../core/utils/string_util.dart';
import '../../../core/widgets/input_text_field.dart';
import '../../../core/widgets/my_btn.dart';
import '../applications/spending/spending_bloc.dart';
import '../businesses/models/spending.dart';
import '../businesses/models/spending_request.dart';

class SpendingScreen extends BaseStateful {
  final Spending? spending;
  const SpendingScreen({
    super.key,
    this.spending,
  });

  @override
  BaseStatefulState createState() => _SpendingScreenState();
}

class _SpendingScreenState extends BaseStatefulState<SpendingScreen> {
  late FocusNode _focusNode;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadingBloc.add(LoadingShowEvent());
    });
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget buildChild(context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          tr(LocaleKeys.spendingScreen_appBarTitle),
          style: TextThemeUtil.instance.titleMedium?.semiBold
              .copyWith(color: Colors.white),
        ),
      ),
      body: Focus(
        focusNode: _focusNode,
        child: GestureDetector(
          onTap: () {
            if (!_focusNode.hasFocus) {
              return;
            }
            _focusNode.unfocus();
          },
          child: BlocProvider<SpendingBloc>(
            create: (context) => SpendingBloc()
              ..add(
                FetchSpendingCategoryEvent(),
              ),
            child: BlocListener<SpendingBloc, SpendingState>(
              listener: (context, state) {
                if (state is SpendingLoaded) {
                  loadingBloc.add(LoadingDismissEvent());
                  return;
                }
                if (state is CreateSpendingRequestSuccess) {
                  MySnackBarUtil.show(
                    context,
                    tr(LocaleKeys.common_createRequestSuccess),
                  );
                  Navigator.pop(context, true);
                  return;
                }
                if (state is CreateSpendingRequestFailure) {
                  MySnackBarUtil.show(
                    context,
                    tr(LocaleKeys.common_createRequestFailure),
                  );
                  return;
                }
              },
              child: _BodyScreen(widget.spending),
            ),
          ),
        ),
      ),
    );
  }
}

class _BodyScreen extends StatefulWidget {
  final Spending? spending;
  _BodyScreen(
    this.spending,
  );
  @override
  State<_BodyScreen> createState() => _BodyScreenState();
}

class _BodyScreenState extends State<_BodyScreen> {
  late TextEditingController _controller;
  late TextEditingController _otherController;
  late TextEditingController _noteController;
  static const _locale = 'en';
  String _formatNumber(String s) =>
      NumberFormat.decimalPattern(_locale).format(int.tryParse(s) ?? 0);

  final GlobalKey<FormState> _key = GlobalKey();

  late SpendingRequest _spendingRequest;
  bool _isOtherCategory = false;

  @override
  void initState() {
    super.initState();
    _spendingRequest = SpendingRequest(
      cost: 0,
      id: widget.spending?.id ?? StringPool.empty,
      createdDate: widget.spending?.createdDate ?? DateTime.now(),
    );
    _otherController = TextEditingController();
    _controller = TextEditingController();
    _noteController = TextEditingController();
    if (widget.spending != null) {
      _isOtherCategory =
          widget.spending!.categoryId == Constants.otherCategoryId;
      String string =
          _formatNumber(widget.spending?.cost.toString() ?? StringPool.empty);
      _controller.value = TextEditingValue(
        text: string,
        selection: TextSelection.collapsed(offset: string.length),
      );
      _otherController.text =
          widget.spending?.otherCategory ?? StringPool.empty;
      _noteController.text = widget.spending?.note ?? StringPool.empty;
      return;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _otherController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Constants.padding),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              tr(LocaleKeys.spendingScreen_whatDidYouSpendToday),
              style: TextThemeUtil.instance.bodyMedium?.regular,
            ),
            SizedBox(
              height: 50,
            ),
            Form(
              key: _key,
              child: Column(
                children: [
                  InputDatePicker(
                    initialDate: _spendingRequest.createdDate,
                    onSubmit: (DateTime value) {
                      _spendingRequest.createdDate = value;
                    },
                  ),
                  SizedBox(
                    height: Constants.spacingBetweenWidget,
                  ),
                  InputTextField(
                    controller: _controller,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    hintText: tr(LocaleKeys.spendingScreen_cost),
                    labelWidget: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: tr(LocaleKeys.spendingScreen_cost),
                            style: TextThemeUtil.instance.bodyMedium,
                          ),
                          TextSpan(
                            text: StringPool.space,
                          ),
                          Constants.redStar,
                        ],
                      ),
                    ),
                    suffixText: Constants.currencySymbol,
                    validator: (value) {
                      if (StringUtil.isNullOrEmpty(value)) {
                        return tr(LocaleKeys.common_requireField);
                      }
                      return null;
                    },
                    onChanged: (string) {
                      string =
                          '${_formatNumber(string.replaceAll(StringPool.comma, StringPool.empty))}';
                      _controller.value = TextEditingValue(
                        text: string,
                        selection:
                            TextSelection.collapsed(offset: string.length),
                      );
                    },
                    onSaved: (value) {
                      if (StringUtil.isNullOrEmpty(value)) return;
                      _spendingRequest.cost = int.parse(
                        value!.replaceAll(StringPool.comma, StringPool.empty),
                      );
                    },
                  ),
                  SizedBox(
                    height: Constants.spacingBetweenWidget,
                  ),
                  BlocBuilder<SpendingBloc, SpendingState>(
                    builder: (context, state) {
                      if (state is! SpendingLoaded) {
                        return Text(tr(LocaleKeys.common_loading));
                      }
                      List<SpendingCategory> spendingCategories =
                          state.spendingCategories;
                      return DropdownButtonFormField2<SpendingCategory>(
                        value: () {
                          if (widget.spending == null) return null;
                          final listTemp = spendingCategories.where((element) =>
                              element.id == widget.spending!.categoryId);
                          if (listTemp.isEmpty) return null;
                          return listTemp.first;
                        }.call(),
                        style: TextThemeUtil.instance.bodyMedium,
                        decoration: InputDecoration(
                          label: Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  tr(LocaleKeys.spendingScreen_spendingType),
                                  style: TextThemeUtil
                                      .instance.bodyMedium?.regular,
                                ),
                                Text(StringPool.space),
                                Text(
                                  StringPool.star,
                                  style: TextThemeUtil.instance.bodyMedium
                                      ?.copyWith(
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(Constants.radius),
                          ),
                        ),
                        isExpanded: true,
                        hint: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              tr(LocaleKeys
                                  .spendingScreen_whatDidYouSpendToday),
                              style: TextThemeUtil
                                  .instance.bodyMedium?.regular.disable,
                            ),
                            Text(StringPool.space),
                            Text(
                              StringPool.star,
                              style:
                                  TextThemeUtil.instance.bodyMedium?.copyWith(
                                color: Colors.red.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                        buttonStyleData: const ButtonStyleData(
                          padding: EdgeInsets.zero,
                          height: 50,
                        ),
                        iconStyleData: const IconStyleData(
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black45,
                          ),
                          iconSize: 30,
                        ),
                        dropdownStyleData: DropdownStyleData(
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(Constants.radius),
                          ),
                        ),
                        items: spendingCategories
                            .map(
                              (spendingCategory) => DropdownMenuItem(
                                onTap: () {},
                                value: spendingCategory,
                                child: Text(
                                    spendingCategory.name ?? StringPool.empty),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value?.id == Constants.otherCategoryId) {
                            setState(() {
                              _isOtherCategory = true;
                            });
                            return;
                          }
                          setState(() {
                            _isOtherCategory = false;
                          });
                          return;
                        },
                        validator: (value) {
                          if (value == null) {
                            return tr(LocaleKeys.common_requireField);
                          }

                          return null;
                        },
                        onSaved: (newValue) {
                          _spendingRequest.categoryId =
                              newValue?.id ?? StringPool.empty;
                          _spendingRequest.categoryName =
                              newValue?.name ?? StringPool.empty;
                        },
                      );
                    },
                  ),
                  if (_isOtherCategory) ...[
                    SizedBox(
                      height: Constants.spacingBetweenWidget,
                    ),
                    InputTextField(
                      textInputAction: TextInputAction.done,
                      controller: _otherController,
                      labelText:
                          tr(LocaleKeys.spendingScreen_spendingTypeOther),
                      hintText: tr(LocaleKeys.spendingScreen_spendingTypeOther),
                      onSaved: (newValue) {
                        _spendingRequest.otherCategory = newValue;
                      },
                    ),
                  ],
                  SizedBox(
                    height: Constants.spacingBetweenWidget,
                  ),
                  InputTextField(
                    textInputAction: TextInputAction.done,
                    controller: _noteController,
                    labelText: tr(LocaleKeys.common_note),
                    hintText: tr(LocaleKeys.common_note),
                    maxLines: Constants.maxLines,
                    onSaved: (newValue) {
                      _spendingRequest.note = newValue;
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            SizedBox(
              height: 55,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  MyOutlineBtn(
                    title: tr(LocaleKeys.common_cancel),
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  MyFilledBtn(
                    title: tr(LocaleKeys.common_confirm),
                    onTap: () {
                      if (_key.currentState?.validate() ?? false) {
                        _key.currentState?.save();
                        BlocProvider.of<SpendingBloc>(context).add(
                          CreateSpendingEvent(_spendingRequest),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
