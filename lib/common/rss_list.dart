const Map<String, String> baonhandanRssList = {
  'Trang chủ': 'https://nhandan.vn/rss/home.rss',
  'Chính trị': 'https://nhandan.vn/rss/chinhtri-1171.rss',
  'Xã luận': 'https://nhandan.vn/rss/xa-luan-1176.rss',
  'Bình luận': 'https://nhandan.vn/rss/binh-luan-phe-phan-1180.rss',
  'Kinh tế': 'https://nhandan.vn/rss/kinhte-1185.rss',
  'Văn hoá': 'https://nhandan.vn/rss/vanhoa-1251.rss',
  'Xã hội': 'https://nhandan.vn/rss/xahoi-1211.rss',
  'Pháp luật': 'https://nhandan.vn/rss/phapluat-1287.rss',
  'Thế giới': 'https://nhandan.vn/rss/thegioi-1231.rss',
  'KH - CN': 'https://nhandan.vn/rss/khoahoc-congnghe-1292.rss'
};

const Map<String, String> congannhandanRssList = {
  'Trang chủ': 'https://cadn.com.vn/tin-moi-nhat.rss',
  'Thời sự': 'https://cadn.com.vn/rss/thoi-su-1.rss',
  'Công an Nhân dân': 'https://cadn.com.vn/rss/cong-an-nhan-dan-5.rss',
  'Pháp luật': 'https://cadn.com.vn/rss/phap-luat-6.rss',
  'Phóng sự - Ký sự': 'https://cadn.com.vn/rss/phong-su-ky-su-79.rss',
  'An ninh - Trật tự': 'https://cadn.com.vn/rss/an-ninh-trat-tu-78.rss',
  'Kinh tế': 'https://cadn.com.vn/rss/kinh-te-12.rss',
  'Văn hoá': 'https://cadn.com.vn/rss/van-hoa-15.rss',
  'Xã hội': 'https://cadn.com.vn/rss/xa-hoi-13.rss',
  'Y tế': 'https://cadn.com.vn/rss/y-te-68.rss',
  'Công nghệ số': 'https://cadn.com.vn/rss/cong-nghe-so-116.rss'
};

const Map<String, String> vnexpressRssList = {
  'Trang chủ': 'https://vnexpress.net/rss/tin-moi-nhat.rss',
  'Thời sự': 'https://vnexpress.net/rss/thoi-su.rss',
  'Thế giới': 'https://vnexpress.net/rss/the-gioi.rss',
  'Kinh doanh': 'https://vnexpress.net/rss/kinh-doanh.rss',
  'Giải trí': 'https://vnexpress.net/rss/giai-tri.rss',
  'Thể thao': 'https://vnexpress.net/rss/the-thao.rss',
  'Pháp luật': 'https://vnexpress.net/rss/phap-luat.rss',
  'Giáo dục': 'https://vnexpress.net/rss/giao-duc.rss',
  'Sức khỏe': 'https://vnexpress.net/rss/suc-khoe.rss',
  'Đời sống': 'https://vnexpress.net/rss/doi-song.rss',
};

class RssMapFile {
  List<Map<String, String>> rssMap = [
    vnexpressRssList,
    baonhandanRssList,
    congannhandanRssList,
  ];
}

class WebsitesList {
  Map<String, Map> websList = {
    "Báo Nhân Dân": baonhandanRssList,
    "VNExpress": vnexpressRssList,
    "Công an Nhân dân": congannhandanRssList,
  };
}
