const supportedRecurringPaymentCurrencyCodes = {'TRY', 'USD', 'EUR', 'GBP'};

bool isSupportedRecurringPaymentCurrency(String code) =>
    supportedRecurringPaymentCurrencyCodes.contains(code.trim().toUpperCase());
