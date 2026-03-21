import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  static const String _baseUrl = 'https://sai.sharedllm.com/v1/chat/completions';
  static const String _model = 'gpt-oss:120b';

  static Future<String> getCompletion(String systemPrompt, String userMessage) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'model': _model,
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': userMessage},
          ],
          'max_tokens': 2048,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] ?? 'No response generated.';
      } else {
        return 'Error: Server returned status ${response.statusCode}. Please try again.';
      }
    } catch (e) {
      return 'Connection error. Please check your internet and try again.';
    }
  }

  static Future<String> analyzeContract(String contractText) async {
    return getCompletion(
      'You are ContractLens AI, an expert legal contract analyst. Analyze contracts for key terms, obligations, rights, deadlines, and potential issues. Provide structured analysis with clear sections. Highlight any unusual or potentially problematic clauses.',
      'Analyze this contract:\n\n$contractText',
    );
  }

  static Future<String> scoreRisk(String contractText) async {
    return getCompletion(
      'You are ContractLens AI, a contract risk assessment specialist. Score contract risk on a scale of 1-100 (100 being highest risk). Break down risks by category: financial, legal, operational, compliance. Provide specific recommendations to mitigate each risk.',
      'Score the risk of this contract:\n\n$contractText',
    );
  }

  static Future<String> explainClause(String clause) async {
    return getCompletion(
      'You are ContractLens AI, a legal clause interpreter. Explain legal clauses in plain, simple language that anyone can understand. Include what the clause means, its implications, and any potential concerns. Use analogies where helpful.',
      'Explain this clause in simple terms:\n\n$clause',
    );
  }

  static Future<String> compareContracts(String contract1, String contract2) async {
    return getCompletion(
      'You are ContractLens AI, a contract comparison expert. Compare two contracts or contract sections. Identify key differences, missing clauses, conflicting terms, and provide recommendations on which is more favorable. Format with clear comparison tables.',
      'Compare these contracts:\n\nContract 1:\n$contract1\n\nContract 2:\n$contract2',
    );
  }
}
