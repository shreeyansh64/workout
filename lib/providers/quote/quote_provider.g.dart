// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getQuotes)
final getQuotesProvider = GetQuotesProvider._();

final class GetQuotesProvider
    extends $FunctionalProvider<AsyncValue<Quote>, Quote, FutureOr<Quote>>
    with $FutureModifier<Quote>, $FutureProvider<Quote> {
  GetQuotesProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'getQuotesProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$getQuotesHash();

  @$internal
  @override
  $FutureProviderElement<Quote> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Quote> create(Ref ref) {
    return getQuotes(ref);
  }
}

String _$getQuotesHash() => r'78cb1bb68e87897ebdad1d3074131e9805534ca9';
