import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../../../core/failure/server_failure.dart';
import '../../data/data_sources/psw_auth_datasourse.dart';
import '../../data/repositories/psw_rigster_repo_impl.dart';
import '../../domain/entities/psw_document.dart';
import '../../domain/usecases/psw_complete_profile_usecase.dart';

part 'pswrigster_event.dart';

part 'pswrigster_state.dart';

class PswRegistrationBloc
    extends Bloc<PswRegistrationEvent, PswRegistrationState> {
  PswRegistrationBloc() : super(const PswRegistrationState()) {
    final dataSource = PswRegistrationRemoteDataSourceImpl();
    final repository = PswRegistrationRepositoryImpl(
      remoteDataSource: dataSource,
    );
    final completeProfileUseCase = CompleteProfileUseCase(repository);

    on<UploadDocumentEvent>((event, emit) {
      final updated = Map<String, String>.from(state.documents);

      final key = event.documentType == PswDocumentType.proofOfId
          ? (event.isFront ? 'proofOfId_front' : 'proofOfId_back')
          : event.documentType.name;

      updated[key] = event.filePath;

      emit(
        state.copyWith(
          documents: Map<String, String>.from(updated),
          clearError: true,
        ),
      );
    });

    on<RemoveDocumentEvent>((event, emit) {
      final updated = Map<String, String>.from(state.documents);
      if (event.documentType == PswDocumentType.proofOfId) {
        final key = event.isFront ? 'proofOfId_front' : 'proofOfId_back';
        updated.remove(key);
      } else {
        updated.remove(event.documentType.name);
      }
      emit(state.copyWith(documents: updated, clearError: true));
    });
    on<SelectIdTypeEvent>((event, emit) {
      emit(state.copyWith(selectedIdType: event.idType));
    });

    on<SubmitDocumentsEvent>((event, emit) async {
      // Validate required documents
      final missing = _missingRequired(state);
      if (missing.isNotEmpty) {
        emit(state.copyWith(error: 'Please upload: ${missing.join(', ')}'));
        return;
      }

      emit(state.copyWith(isLoading: true, clearError: true));

      final params = CompleteProfileParams(
        proofIdentityType: state.selectedIdType.apiValue,
        workStatus: true,
        // adjust based on UI input if needed
        proofIdentityFilePath: state.documents['proofOfId_front']!,
        pswCertificateFilePath:
            state.documents[PswDocumentType.pswCertificate.name]!,
        cvFilePath: state.documents[PswDocumentType.cv.name]!,
        immunizationRecordFilePath:
            state.documents[PswDocumentType.immunizationRecord.name]!,
        criminalRecordFilePath:
            state.documents[PswDocumentType.criminalRecord.name]!,
        firstAidOrCprFilePath:
            state.documents[PswDocumentType.firstAidCpr.name],
      );

      final result = await completeProfileUseCase(params);

      result.fold((failure) {
        final msg = failure is ServerFailure
            ? (failure.messageEn ?? failure.message ?? 'Submission failed')
            : 'Something went wrong';
        emit(state.copyWith(isLoading: false, error: msg));
      }, (_) => emit(state.copyWith(isLoading: false, isSubmitted: true)));
    });
  }

  List<String> _missingRequired(PswRegistrationState s) {
    final missing = <String>[];
    if (!s.isDocumentUploaded(PswDocumentType.proofOfId)) {
      missing.add('Proof of Identity');
    }
    if (!s.isDocumentUploaded(PswDocumentType.pswCertificate)) {
      missing.add('PSW Certificate');
    }
    if (!s.isDocumentUploaded(PswDocumentType.cv)) missing.add('CV');
    if (!s.isDocumentUploaded(PswDocumentType.immunizationRecord)) {
      missing.add('Immunization Record');
    }
    if (!s.isDocumentUploaded(PswDocumentType.criminalRecord)) {
      missing.add('Criminal Record');
    }
    return missing;
  }
}
