import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:team_egypt_v3/core/models/checkout_items.dart';
import 'package:team_egypt_v3/core/models/offer_class.dart';
import 'package:team_egypt_v3/core/models/subscription_model.dart';
import 'package:team_egypt_v3/core/utils/string_extensions.dart';
import 'package:team_egypt_v3/core/utils/validators.dart';
import 'package:team_egypt_v3/core/widgets/modern_toast.dart';
import 'package:team_egypt_v3/features/dash_board/screens/partnerships_screen/data/supabase_partnership.dart';
import 'package:team_egypt_v3/features/time_screen/logic/in_team_cubit.dart';
import 'package:team_egypt_v3/features/time_screen/logic/time_screen_cubit/time_screen_cubit.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/dialogs/barcode_dialog.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/dialogs/checkin_dialog.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/dialogs/checkout_dialog.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/dialogs/chekcout_button_dialog.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/dialogs/subscription_end_dialog.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/dialogs/subscription_valid_dialog.dart';
import 'package:toastification/toastification.dart';

class TimeScreenLogic {
  static double applyOffer(double total, double hours, OfferClass? offer) {
    if (offer == null) return total;
    if (total == 80) {
      hours = 5;
    }

    switch (offer.type) {
      case "percentage":
        return total - (total * offer.value / 100);

      case "fixed":
        return (total - offer.value).clamp(0, double.infinity);

      case "freeHour":
        final chargeableHours = (hours - offer.value).clamp(0, double.infinity);
        if (total == 0) {
          return total;
        } else {
          return (chargeableHours * Validators.hourFee).roundToDouble();
        }

      case "freeItem":
        // price stays same, but you can track free item separately
        return total;
    }
    return total;
  }

  static Future<String> getPartnerShipName(String code) async {
    return SupabasePartnership.getPartnershipName(code);
  }

  static void showCheckinDialog(BuildContext context) {
    final numberController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => CheckinDialog(numberController: numberController),
    );
  }

  static Future<void> tryInsertUser(
    BuildContext context,
    TextEditingController numberController,
  ) async {
    final number = numberController.text.trim();

    // Validate number
    final numberValid = RegExp(r'^\d{11}$').hasMatch(number);
    if (!numberValid) {
      ModernToast.showToast(
        context,
        'Warning',
        'Number must be exactly 11 digits',
        ToastificationType.warning,
      );
      return;
    }

    final sub = await context.read<TimeScreenCubit>().getSupbscriptionByNumber(
      number,
    );

    if (sub != null) {
      Navigator.of(context).pop();
      final planMin = sub.planHours * 60;

      if (sub.endDate.isBefore(DateTime.now())) {
        showSubscriptionEndedDialog(context, sub, numberController, number);
      } else {
        if (planMin < sub.hours && sub.planHours != 0 ||
            planMin == sub.hours && sub.planHours != 0) {
          showSubscriptionEndedDialog(context, sub, numberController, number);
        } else {
          showSubscriptionValidDialog(context, sub, numberController, number);
        }
      }
    } else {
      final newUser = await context.read<TimeScreenCubit>().insertInTeam(
        number,
        context,
      );

      if (newUser != null) {
        BlocProvider.of<InTeamCubit>(context).loadUsers();
        numberController.clear();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).pop();
        });
        ModernToast.showToast(
          context,
          'Success',
          'User added successfully',
          ToastificationType.success,
        );
        await Hive.openBox<CheckoutItems>(number);
      } else {
        ModernToast.showToast(
          context,
          'Error',
          'User not found',
          ToastificationType.error,
        );
      }
    }
  }

  static void showSubscriptionEndedDialog(
    BuildContext context,
    SubscriptionModel sub,
    TextEditingController numberController,
    String number,
  ) {
    showDialog(
      context: context,
      builder: (context) => SubscriptionEndedDialog(
        sub: sub,
        number: number,
        numberController: numberController,
      ),
    );
  }

  static void showSubscriptionValidDialog(
    BuildContext context,
    SubscriptionModel sub,
    TextEditingController numberController,
    String number,
  ) {
    final remaining = sub.endDate.difference(DateTime.now());
    final planMin = sub.planHours * 60;
    final remainingTima = planMin - sub.hours;
    final remText = StringExtensions.formatMinutesToHoursMinutes(remainingTima);
    showDialog(
      context: context,
      builder: (context) => SubscriptionValidDialog(
        remaining: remaining,
        remText: remText,
        sub: sub,
        number: number,
        numberController: numberController,
      ),
    );
  }

  static Future<void> checkoutButtonUser(BuildContext perantcontext) async {
    final numberController = TextEditingController();

    showDialog(
      context: perantcontext,
      builder: (dialogCtx) => ChekcoutButtonDialog(
        numberController: numberController,
        perantcontext: perantcontext,
        dialogCtx: dialogCtx,
      ),
    );
  }

  static Future<void> tryCheckoutUser(
    BuildContext context,
    TextEditingController numberController,
  ) async {
    final number = numberController.text.trim();
    TextEditingController priceController = TextEditingController();
    // Validate number
    final numberValid = RegExp(r'^\d{11}$').hasMatch(number);
    if (!numberValid) {
      ModernToast.showToast(
        context,
        'Warning',
        'Number must be exactly 11 digits',
        ToastificationType.warning,
      );
      return;
    }

    // final user = await SupabaseInTeam.getInTeam(number);
    final user = await context.read<TimeScreenCubit>().getInTeamUser(number);

    if (user == null) {
      ModernToast.showToast(
        context,
        'Error',
        "This number didn't checkin",
        ToastificationType.error,
      );
      return;
    }

    await Hive.openBox<CheckoutItems>(user.number);
    final now = DateTime.now();
    final duration = now.difference(user.timer);
    double hours = duration.inMinutes / 60;
    final shours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

    final durationString = '$shours:$minutes:$seconds';
    final int timeSpent = duration.inMinutes;

    double baseTotal = (hours * Validators.hourFee).roundToDouble();
    if (baseTotal > 80) {
      baseTotal = 80;
    }

    if (user.isSub) {
      final sub = await context
          .read<TimeScreenCubit>()
          .getSupbscriptionByNumber(user.number);
      final int planMin = sub!.planHours * 60;

      if (timeSpent + sub.hours > planMin && planMin != 0) {
        final totalTime = (timeSpent + sub.hours) - planMin;
        baseTotal = totalTime / 60 * Validators.hourFee;
        hours = totalTime / 60;
      } else {
        baseTotal = 0;
        hours = 0;
      }
    }
    final offer = await SupabasePartnership.getOfferByCode(
      user.partnershipCode,
    );
    final finalTotal = TimeScreenLogic.applyOffer(baseTotal, hours, offer);
    late String offerDis;
    if (user.isSub && offer != null) {
      offerDis = "Subscribed And ${offer.description}";
    } else {
      offerDis = user.isSub
          ? "Subscribed"
          : (offer != null ? offer.description : "No Offer");
    }
    print("beffor the get total done");

    context.read<TimeScreenCubit>().getTotal(Validators.choosenDay);

    print("After the get total");

    showDialog(
      context: context,
      builder: (_) {
        return BlocBuilder<TimeScreenCubit, TimeScreenState>(
          builder: (context, state) {
            return CheckoutDialog(
              baseTotal: baseTotal,
              offerDis: offerDis,
              finalTotal: finalTotal,
              user: user,
              priceController: priceController,
              durationString: durationString,
              timeSpent: timeSpent,
            );
          },
        );
      },
    );
  }

  // New Logic #####################

  static void addPersonButtonLogic({
    required TextEditingController nameController,
    required TextEditingController numberController,
    required TextEditingController collageConroller,
    required TextEditingController partnershipCodeController,
    required BuildContext context,
  }) async {
    final name = nameController.text.trim();
    final number = numberController.text.trim();
    final collage = collageConroller.text.trim();
    final partnershipCode = partnershipCodeController.text.trim();

    // Number: exactly 11 digits
    final numberValid = RegExp(r'^\d{11}$').hasMatch(number);

    // Partnership code: 5 letters/numbers only (no shapes)
    final codeValid = RegExp(r'^[A-Za-z0-9]{5}$').hasMatch(partnershipCode);

    if (!numberValid) {
      ModernToast.showToast(
        context,
        'Warning',
        'Number must be exactly 11 digits',
        ToastificationType.warning,
      );
      return;
    }

    if (!codeValid) {
      ModernToast.showToast(
        context,
        'Warning',
        'Partnership code must be 5 letters/numbers only',
        ToastificationType.warning,
      );
      return;
    }

    final isInserted = await context.read<TimeScreenCubit>().insertCustomer(
      context,
      name,
      number,
      collage,
      partnershipCode,
    );

    if (isInserted == true) {
      final user = await context.read<TimeScreenCubit>().getUserData(number);

      await context.read<TimeScreenCubit>().insertInTeam(user!.number, context);

      ModernToast.showToast(
        context,
        'Success',
        'Customer Added Successfully',
        ToastificationType.success,
      );

      BlocProvider.of<InTeamCubit>(context).loadUsers();
      Navigator.of(context).pop();

      showDialog(
        context: context,
        builder: (context) => BarcodeDialog(user: user),
      );
    } else {
      ModernToast.showToast(
        context,
        'Error',
        'Customer Already Exist',
        ToastificationType.error,
      );
    }
  }
}
