import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class ChatEvent {}
class SendMessage extends ChatEvent {
  final String message;
  SendMessage(this.message);
}

// States
abstract class ChatState {}
class ChatInitial extends ChatState {}
class ChatMessageSent extends ChatState {}

// Bloc
class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    on<SendMessage>((event, emit) {
      // Logic to send message to LLM
      emit(ChatMessageSent());
    });
  }
}
