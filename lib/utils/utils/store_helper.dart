import 'package:mobx/mobx.dart';

bool isStateLoading(ObservableFuture futureData) {
  return futureData.status == FutureStatus.pending;
}

void disposeStore(List<ReactionDisposer>? disposers) {
  if (disposers != null) {
    disposers.forEach((disposer) {
      disposer();
    });
  }
}
