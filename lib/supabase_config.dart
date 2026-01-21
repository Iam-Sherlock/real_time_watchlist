
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static String supabaseUrl = 'https://nlmqeljixrhhsvnmzlyp.supabase.co';
  static String supabaseAnonKey ='eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5sbXFlbGppeHJoaHN2bm16bHlwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Njg5MTI4MzgsImV4cCI6MjA4NDQ4ODgzOH0.mOxGe5c-EGbcQma2maMXKfJzG6F9dEBh4i9CxeR1yhw';
  final supabase = Supabase.instance.client;
}