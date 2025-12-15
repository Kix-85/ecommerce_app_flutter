import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  // TODO: Replace with your actual Supabase URL and Anon Key
  static const String supabaseUrl = 'https://iucwsuasskuvteqygurm.supabase.co';
  static const String supabaseAnonKey = 'sb_publishable_VFSjSTxueQrvfpJXev0QVw_jYcoLfy8';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
