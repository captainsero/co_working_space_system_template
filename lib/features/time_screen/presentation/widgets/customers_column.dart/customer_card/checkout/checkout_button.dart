import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:team_egypt_v3/core/models/checkout_items.dart';
import 'package:team_egypt_v3/core/models/in_team_users.dart';
import 'package:team_egypt_v3/core/utils/validators.dart';
import 'package:team_egypt_v3/features/dash_board/screens/partnerships_screen/data/supabase_partnership.dart';
import 'package:team_egypt_v3/features/dash_board/screens/subscriptions/data/supabase_subscriptions.dart';
import 'package:team_egypt_v3/features/time_screen/logic/time_screen_cubit/time_screen_cubit.dart';
import 'package:team_egypt_v3/features/time_screen/logic/time_screen_logic.dart';
import 'package:team_egypt_v3/features/time_screen/presentation/widgets/dialogs/checkout_dialog.dart';

class CheckoutButton extends StatefulWidget {
  const CheckoutButton({super.key, required this.timer, required this.user});
  final DateTime timer;
  final InTeamUsers user;

  @override
  State<CheckoutButton> createState() => _CheckoutButtonState();
}

class _CheckoutButtonState extends State<CheckoutButton> {
  @override
  Widget build(BuildContext context) {
    TextEditingController priceController = TextEditingController();
    return TextButton.icon(
      onPressed: () async {
        await Hive.openBox<CheckoutItems>(widget.user.number);
        final now = DateTime.now();
        final duration = now.difference(widget.timer);
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

        if (widget.user.isSub) {
          final sub = await SupabaseSubscriptions.getSubscriptionByNumber(
            widget.user.number,
          );
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
          widget.user.partnershipCode,
        );
        final finalTotal = TimeScreenLogic.applyOffer(baseTotal, hours, offer);
        late String offerDis;
        if (widget.user.isSub && offer != null) {
          offerDis = "Subscribed And ${offer.description}";
        } else {
          offerDis = widget.user.isSub
              ? "Subscribed"
              : (offer != null ? offer.description : "No Offer");
        }

        context.read<TimeScreenCubit>().getTotal(Validators.choosenDay);

        showDialog(
          context: context,
          builder: (_) {
            return BlocBuilder<TimeScreenCubit, TimeScreenState>(
              builder: (context, state) {
                return CheckoutDialog(
                  baseTotal: baseTotal,
                  offerDis: offerDis,
                  finalTotal: finalTotal,
                  user: widget.user,
                  priceController: priceController,
                  durationString: durationString,
                  timeSpent: timeSpent,
                  hours: hours,
                );
              },
            );
          },
        );
      },
      icon: Icon(Icons.logout),
      label: Text("Checkout"),
    );
  }
}
