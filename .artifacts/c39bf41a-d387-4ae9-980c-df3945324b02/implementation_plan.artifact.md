# Fix `submitEquiry` method in `DeveloperRepo`

The `submitEquiry` method in `DeveloperRepo` has several issues including a typo in the method name, syntax errors in the API call (static call to an instance method), missing return statement, and missing error handling.

## Proposed Changes

### [Developer Module]

#### [MODIFY] [developer_repo.dart](file:///Users/macbook/Documents/GitHub/GharMB-user-app/lib/features/developer/repo/developer_repo.dart)
- Rename `submitEquiry` to `submitEnquiry`.
- Add `message` as a required parameter to `submitEnquiry` because `EnquirySubmitPayload` requires it.
- Correct the `postApi` call to instantiate `EnquirySubmitPayload`.
- Add `try-catch` block for error handling.
- Return `true` if the response is not null, otherwise `false`.

#### [MODIFY] [app_urls.dart](file:///Users/macbook/Documents/GitHub/GharMB-user-app/lib/core/constants/app_urls.dart)
- Simplify `enquiry` URL definition if the `developerId` is not actually used in the path (it's passed in the body). However, I will keep it as a function if it's expected to be a function, but I might fix it to actually use the ID if that's the standard for the backend. Looking at the other URLs, some use parameters and some don't. Given it's a POST request for an enquiry, having it in the body is standard.

## Verification Plan

### Manual Verification
- I will check if the code compiles after the changes.
- I will verify that `submitEnquiry` correctly constructs the payload.
