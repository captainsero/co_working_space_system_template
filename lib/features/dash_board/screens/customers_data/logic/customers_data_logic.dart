import 'package:team_egypt_v3/features/dash_board/screens/customers_data/data/supabase_customers_data.dart';

class CustomersDataLogic {
  static Future<List<Map<String, dynamic>>> getUsersPaginated(
    int limit,
    int offset,
    bool id,
  ) {
    if (id) {
      return SupabaseCustomersData.getUsersPaginatedId(
        limit: limit,
        offset: offset,
      );
    } else {
      return SupabaseCustomersData.getUsersPaginated(
        limit: limit,
        offset: offset,
      );
    }
  }
}
