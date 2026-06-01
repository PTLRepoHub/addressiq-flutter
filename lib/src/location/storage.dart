import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/models.dart';

const _configKey = '@addressiq:config';
const _queueKey = '@addressiq:queue';
const _metaKey = '@addressiq:meta';
const _maxQueueSize = 500;

class AddressIQStorage {
  static Future<void> saveConfig(Map<String, dynamic> config) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_configKey, jsonEncode(config));
  }

  static Future<Map<String, dynamic>?> loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_configKey);
    return raw != null ? jsonDecode(raw) as Map<String, dynamic> : null;
  }

  static Future<void> clearConfig() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_configKey);
  }

  static Future<int> pushEvents(List<LocationEvent> events) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_queueKey);
    final queue = raw != null
        ? (jsonDecode(raw) as List).cast<Map<String, dynamic>>()
        : <Map<String, dynamic>>[];

    queue.addAll(events.map((e) => e.toJson()));
    if (queue.length > _maxQueueSize) {
      queue.removeRange(0, queue.length - _maxQueueSize);
    }
    await prefs.setString(_queueKey, jsonEncode(queue));
    return queue.length;
  }

  static Future<List<Map<String, dynamic>>> popEvents(int count) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_queueKey);
    if (raw == null) return [];

    final queue = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    final batch = queue.take(count).toList();
    queue.removeRange(0, batch.length);
    await prefs.setString(_queueKey, jsonEncode(queue));
    return batch;
  }

  static Future<int> queueSize() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_queueKey);
    if (raw == null) return 0;
    return (jsonDecode(raw) as List).length;
  }

  static Future<void> returnEvents(List<Map<String, dynamic>> events) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_queueKey);
    final queue = raw != null
        ? (jsonDecode(raw) as List).cast<Map<String, dynamic>>()
        : <Map<String, dynamic>>[];
    queue.insertAll(0, events);
    if (queue.length > _maxQueueSize) {
      queue.removeRange(0, queue.length - _maxQueueSize);
    }
    await prefs.setString(_queueKey, jsonEncode(queue));
  }

  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_configKey);
    await prefs.remove(_queueKey);
    await prefs.remove(_metaKey);
  }
}
