import 'package:flutter/material.dart';
import 'package:cms_web/features/shared/views/landing_page_web.dart';
import 'package:cms_web/features/authentication/views/pages/login/login.dart';
import 'package:cms_web/features/workorder/views/workorder_stream_screen.dart';
import 'package:cms_web/features/clientapp/views/profile/client_stream_screen.dart';
import 'package:cms_web/features/hcpapp/views/profile/hcprofessional_stream_screen.dart';
import 'package:cms_web/features/shared/utils/routerconstants.dart';
import 'package:cms_web/features/clientapp/views/client_menu.dart';
//import 'package:cms_web/web/services/cms_auth_service.dart';
import 'package:flutter/services.dart';
import 'package:cms_web/features/clientapp/views/profile/client_address_profile_page.dart';
import 'package:cms_web/features/clientapp/views/profile/client_cannot_be_scheduled_profile_page.dart';
import 'package:cms_web/features/clientapp/views/profile/client_contact_profile_page.dart';
import 'package:cms_web/features/clientapp/views/profile/client_credentials_profile_page.dart';
import 'package:cms_web/features/clientapp/views/profile/client_credit_profile_page.dart';
import 'package:cms_web/features/clientapp/views/profile/client_department_profile_page.dart';
import 'package:cms_web/features/clientapp/views/profile/client_profile_page.dart';
import 'package:cms_web/features/clientapp/views/profile/client_user_profile_page.dart';
//scheduling
import 'package:cms_web/features/clientapp/views/scheduling/client_approve_shifts_scheduling_page.dart';
import 'package:cms_web/features/clientapp/views/scheduling/client_cancel_shifts_scheduling_page.dart';
import 'package:cms_web/features/clientapp/views/scheduling/client_confirm_shifts_scheduling_page.dart';
import 'package:cms_web/features/clientapp/views/scheduling/client_do_not_schedule_list_scheduling_page.dart';
import 'package:cms_web/features/clientapp/views/scheduling/client_list_schedule_scheduling_page.dart';
import 'package:cms_web/features/clientapp/views/scheduling/client_republish_shifts_scheduling_page.dart';
import 'package:cms_web/features/clientapp/views/scheduling/client_schedule_shifts_scheduling_page.dart';
import 'package:cms_web/features/clientapp/views/scheduling/client_schedule_view_scheduling_page.dart';
import 'package:cms_web/features/clientapp/views/scheduling/client_set_dns_scheduling_page.dart';
import 'package:cms_web/features/clientapp/views/scheduling/client_timecard_approval_scheduling_page.dart';
import 'package:cms_web/features/clientapp/views/scheduling/client_mitigate_ot_scheduling_page.dart';

//import 'package:cms_web/web/services/cms_auth_service.dart';
//hcp
import 'package:cms_web/features/hcpapp/views/hcp_menu.dart';
//hcp profile
import 'package:cms_web/features/hcpapp/views/profile/process_hcp_credential_data.dart';
import 'package:cms_web/features/hcpapp/views/profile/process_hcp_profile_address_data.dart';
import 'package:cms_web/features/hcpapp/views/profile/process_hcp_profile_contact_data.dart';
import 'package:cms_web/features/hcpapp/views/profile/process_hcp_profile_special_rate_data.dart';
//import 'package:cms_web/features/hcpapp/views/profile/process_hcp_profile_hr_data.dart';
import 'package:cms_web/features/hcpapp/views/profile/process_hcp_profile_data.dart';
//hcp scheduling
import 'package:cms_web/features/hcpapp/views/scheduling/process_hcp_available_shifts.dart';
import 'package:cms_web/features/hcpapp/views/scheduling/process_hcp_cancel_shift.dart';
import 'package:cms_web/features/hcpapp/views/scheduling/process_hcp_confirmed_shifts.dart';
import 'package:cms_web/features/hcpapp/views/scheduling/process_hcp_list_dnu.dart';
import 'package:cms_web/features/hcpapp/views/scheduling/process_hcp_payments.dart';
import 'package:cms_web/features/hcpapp/views/scheduling/show_hcp_payment_details_screen.dart';
import 'package:cms_web/features/shared/widgets/hcp_show_payment_pdf.dart';
import 'package:cms_web/features/hcpapp/views/scheduling/process_hcp_schedule_view.dart';
import 'package:cms_web/features/shared/views/landing_page_web.dart';

import 'package:cms_web/features/hcpapp/views/scheduling/process_hcp_show_confirmed_shifts.dart';
import 'package:cms_web/features/shared/widgets/show_hcp_document_pdf.dart';
class MyRoutes {
  //AuthService authService = AuthService();
  static Route<dynamic> generateRoute(RouteSettings settings) {
    debugPrint('line 10: $settings ${settings.name}');
    switch (settings.name) {
      case homePage:
        debugPrint('line 36 routes ');
        return MaterialPageRoute(
            builder: (context) => Login(flagGetAPNS: false));
      case loginPage:
        debugPrint('line 40 routes');
        return MaterialPageRoute(
            builder: (context) => Login(flagGetAPNS: false));
      case landingPage:
        return MaterialPageRoute(
            builder: (context) => LandingPageWeb());
      case workOrderPage:
        return MaterialPageRoute(builder: (context) => WorkOrderStreamScreen());
      case clientPage:
        Map<String, String> mp = settings.arguments as Map<String, String>;
        return MaterialPageRoute(
            builder: (context) => ClientStreamScreen(args: mp));
      case hcprofessionalPage:
        Map<String, dynamic> mp = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => HCProfessionalStreamScreen(args: mp));
      case clientMenu:
        debugPrint('line 67 client menu');
        Map<String, dynamic> mp = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (context) => ClientMenu(args: mp));
      case clientProfilePage:
        Map<String, dynamic> mp = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => ClientProfilePage(args: mp));
      case clientUserProfilePage:
        Map<String, dynamic> mp = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => ClientUserProfilePage(args: mp));
      case clientAddressProfilePage:
        Map<String, dynamic> mp = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => ClientAddressProfilePage(args: mp));
      case clientContactProfilePage:
        Map<String, dynamic> mp = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => ClientContactProfilePage(args: mp));
      case clientCreditProfilePage:
        Map<String, dynamic> mp = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => ClientCreditProfilePage(args: mp));
      case clientDepartmentProfilePage:
        Map<String, dynamic> mp = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => ClientDepartmentProfilePage(args: mp));
      case clientCredentialsProfilePage:
        debugPrint('line 83 clientcredentialsprofilepage');
        Map<String, dynamic> mp = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => ProcessClientRequestSchedule(args: mp));
      case clientCannotBeScheduledProfilePage:
        Map<String, dynamic> mp = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => ClientCannotBeScheduledProfilePage(args: mp));

      //scheduling
      case clientSchedulingMenu:
        debugPrint('line 105: cancel shift');
        Map<String, dynamic> mp = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (context) => ClientMenu(args: mp));
      case clientCancelShiftsSchedulingPage:
        debugPrint('line 105: cancel shift');
        Map<String, dynamic> mp = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => ClientCancelShiftsSchedulingPage(args: mp));
      case clientRepublishShiftsSchedulingPage:
        Map<String, dynamic> mp = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) =>
                ClientRepublishShiftsSchedulingPage(args: mp));
      case clientScheduleShiftsSchedulingPage:
        Map<String, dynamic> mp = settings.arguments as Map<String, dynamic>;
        print('line 136 $mp');
        return MaterialPageRoute(
            builder: (context) => ProcessClientRequestSchedule(args: mp));
      case clientApproveShiftsSchedulingPage:
        Map<String, dynamic> mp = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => ClientApproveShiftsSchedulingPage(args: mp));
      // case clientConfirmShiftsSchedulingPage:
      //   Map<String, dynamic> mp = settings.arguments as Map<String, dynamic>;
      //   return MaterialPageRoute(
      //       builder: (context) => ClientConfirmShiftsSchedulingPage(args: mp));
      case clientListScheduleSchedulingPage:
        Map<String, dynamic> mp = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => ClientListScheduleSchedulingPage(args: mp));
      case clientScheduleViewSchedulingPage:
        Map<String, dynamic> mp = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => ClientScheduleViewSchedulingPage(args: mp));
      case clientDoNotScheduleListSchedulingPage:
        Map<String, dynamic> mp = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) =>
                ClientDoNotScheduleListSchedulingPage(args: mp));
      case clientSetDNSSchedulingPage:
        Map<String, dynamic> mp = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => ClientSetDNSSchedulingPage(args: mp));
      case clientTimecardApprovalSchedulingPage:
        Map<String, dynamic> mp = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) =>
                ClientTimecardApprovalSchedulingPage(args: mp));
      case clientMitigateOTSchedulingPage:
        Map<String, dynamic> mp = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => ClientMitigateOTSchedulingPage(args: mp));

      case landingPageWeb:
        return MaterialPageRoute(builder: (context) => LandingPageWeb());
      //hcp
      case hcpMenu:
        debugPrint('line 67 client menu');
        Map<String, dynamic> mp = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (context) => HCPMenu(args: mp));

      //ncpprofile
      case hcpProfileData:
        Map<String, dynamic> mp = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => ProcessHCPProfileData(args: mp));
      case hcpCredentialData:
        Map<String, dynamic> mp = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => ProcessHCPCredential(args: mp));
      case hcpProfileAddressData:
        Map<String, dynamic> mp = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => ProcessHCPProfileAddressData(args: mp));
      case hcpProfileContactData:
        Map<String, dynamic> mp = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => ProcessHCPProfileContactData(args: mp));
      case hcpProfileSpecialRateData:
        Map<String, dynamic> mp = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => ProcessHCPProfileSpecialRateData(args: mp));
      // case hcpProfileHRData:
      //   Map<String, dynamic> mp = settings.arguments as Map<String, dynamic>;
      //   return MaterialPageRoute(
      //       builder: (context) => ProcessHCPProfileHRData(args: mp));
      // //hcpscheduling
      case hcpProcessAvailableShifts:
        Map<String, dynamic> mp = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => ProcessHCPAvailableShifts(args: mp));
      case hcpProcessCancelShifts:
        Map<String, dynamic> mp = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => ProcessHCPCancelShifts(args: mp));
      case hcpPaymentData:
        Map<String, dynamic> mp = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => ProcessHCPPayments(args: mp));
      case hcpPaymentDetailsData:
        Map<String, dynamic> mp = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => ShowHCPPaymentDetailsScreen(args: mp));
      case showPaymentPDF:
        debugPrint('line 219: ${settings.arguments}');
        Map<String, dynamic> mp = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => HCPShowPaymentPDF (args: mp));
      case hcpScheduledView:
        Map<String, dynamic> mp = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => ProcessHCPScheduleView(args: mp));
      case hcpConfirmedShifts:
        Map<String, dynamic> mp = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => ProcessHCPConfirmedShifts(args: mp));
      case hcpListDNUs:
        Map<String, dynamic> mp = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (context) => ProcessHCPDNU(args: mp));
      default:
        return MaterialPageRoute(
            builder: (context) => Login(flagGetAPNS: false));
    }
  }
}
