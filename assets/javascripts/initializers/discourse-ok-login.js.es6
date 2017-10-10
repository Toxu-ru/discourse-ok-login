import Sharing from 'discourse/lib/sharing';

export default {
  name: 'discourse-ok-login',

  initialize: function() {

    Sharing.addSource({
      id: 'Odnoklassniki',
      faIcon: 'fa-ok',
      generateUrl: function(link, title) {
        // https://ok.com/dev/share_details
        return "http://ok.com/share.php?url=" + encodeURIComponent(link) + "&title=" + encodeURIComponent(title);
      },
      shouldOpenInPopup: true,
      title: I18n.t('share.odnoklassniki'),
      popupHeight: 370
    });

  }
};
