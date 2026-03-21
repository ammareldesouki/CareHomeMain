import 'package:bloc/bloc.dart';

import '../../../../../core/failure/server_failure.dart';
import '../../data/data_sources/psw_auth_datasourse.dart';
import '../../data/models/signup_register_psw.dart';
import '../../data/repositories/psw_rigster_repo_impl.dart';
import '../../domain/entities/psw_document.dart';
import '../../domain/usecases/psw_complete_profile_usecase.dart';
import '../../domain/usecases/psw_signup_usecases.dart';


part 'pswrigster_event.dart';
part 'pswrigster_state.dart';

class PswRegistrationBloc
    extends Bloc<PswRegistrationEvent, PswRegistrationState> {
  PswRegistrationBloc() : super(const PswRegistrationState()) {
    final dataSource = PswRegistrationRemoteDataSourceImpl();
    final repository = PswRegistrationRepositoryImpl(
      remoteDataSource: dataSource,
    );
    final registerPswUseCase = RegisterPswUseCase(repository);
    final completeProfileUseCase = CompleteProfileUseCase(repository);

    // ── Register PSW ─────────────────────────────────────────────────────────
    on<RegisterPswEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true, clearError: true));

      final result = await registerPswUseCase(event.request);

      result.fold(
            (failure) {
          final msg = failure is ServerFailure
              ? (failure.message ?? 'Registration failed')
              : 'Something went wrong';
          emit(state.copyWith(isLoading: false, error: msg));
        },
            (entity) =>
            emit(state.copyWith(isLoading: false, isRegistered: true)),
      );
    });

    // ── Document helpers ──────────────────────────────────────────────────────
    on<UploadDocumentEvent>((event, emit) {
      final updated = Map<String, String>.from(state.documents);
      final key = event.documentType == PswDocumentType.proofOfId
          ? (event.isFront ? 'proofOfId_front' : 'proofOfId_back')
          : event.documentType.name;
      updated[key] = event.filePath;
      emit(state.copyWith(
          documents: Map<String, String>.from(updated), clearError: true));
    });

    on<RemoveDocumentEvent>((event, emit) {
      final updated = Map<String, String>.from(state.documents);
      if (event.documentType == PswDocumentType.proofOfId) {
        updated.remove(event.isFront ? 'proofOfId_front' : 'proofOfId_back');
      } else {
        updated.remove(event.documentType.name);
      }
      emit(state.copyWith(documents: updated, clearError: true));
    });

    on<SelectIdTypeEvent>((event, emit) {
      emit(state.copyWith(selectedIdType: event.idType));
    });

    on<SetWorkStatusEvent>((event, emit) {
      emit(state.copyWith(workStatus: event.workStatus));
    });

    // ── Submit documents ──────────────────────────────────────────────────────
    on<SubmitDocumentsEvent>((event, emit) async {
      final missing = _missingRequired(state);
      if (missing.isNotEmpty) {
        emit(state.copyWith(error: 'Please upload: ${missing.join(', ')}'));
        return;
      }

      emit(state.copyWith(isLoading: true, clearError: true));

      final params = CompleteProfileParams(
        proofIdentityType: state.selectedIdType.apiValue,
        workStatus: state.workStatus,
        // ✅ use actual state value
        proofIdentityFilePath: state.documents['proofOfId_front']!,
        pswCertificateFilePath: state.documents[PswDocumentType.pswCertificate
            .name]!,
        cvFilePath: state.documents[PswDocumentType.cv.name]!,
        immunizationRecordFilePath: state.documents[PswDocumentType
            .immunizationRecord.name]!,
        criminalRecordFilePath: state.documents[PswDocumentType.criminalRecord
            .name]!,
        firstAidOrCprFilePath: state.documents[PswDocumentType.firstAidCpr
            .name],
      );

      final result = await completeProfileUseCase(params);

      result.fold(
            (failure) {
          final msg = failure is ServerFailure
              ? (failure.message ?? 'Submission failed')
              : 'Something went wrong';
          emit(state.copyWith(isLoading: false, error: msg));
        },
            (_) => emit(state.copyWith(isLoading: false, isSubmitted: true)),
      );
    });
  }

  List<String> _missingRequired(PswRegistrationState s) {
    final missing = <String>[];
    if (!s.isDocumentUploaded(PswDocumentType.proofOfId)) missing.add(
        'Proof of Identity');
    if (!s.isDocumentUploaded(PswDocumentType.pswCertificate)) missing.add(
        'PSW Certificate');
    if (!s.isDocumentUploaded(PswDocumentType.cv)) missing.add('CV');
    if (!s.isDocumentUploaded(PswDocumentType.immunizationRecord)) missing.add(
        'Immunization Record');
    if (!s.isDocumentUploaded(PswDocumentType.criminalRecord)) missing.add(
        'Criminal Record');
    return missing;
  }
}