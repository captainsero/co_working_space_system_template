part of 'tools_cubit.dart';

sealed class ToolsState extends Equatable {
  const ToolsState();

  @override
  List<Object> get props => [];
}

final class ToolsInitial extends ToolsState {}

final class ToolsLoading extends ToolsState {}

final class ToolsGet extends ToolsState {
  final List<ToolsModel> tools;

  const ToolsGet({required this.tools});

  @override
  List<Object> get props => [tools];
}
