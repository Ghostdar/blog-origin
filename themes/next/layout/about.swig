{% extends '_layout.swig' %}
{% import '_macro/about.swig' as post_template %}
{% import '_macro/sidebar.swig' as sidebar_template %}
{% block content %}
  <script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=rA8WIq7HI0klFT9mlms6xs7DUGWRVG57"  ></script>
  <div id = "about">
    <div id="posts" class="posts-expand">
      {{ post_template.render(page) }}
    </div>
    <div class="right">

    </div>
    <div id = "baiduWrap"><div id="baiduMap" style="width:100%;height:100%;"> </div></div>
  </div> 

  <script type="text/javascript" >
    // 百度地图API功能
    var map = new BMap.Map("baiduMap");
    var point = new BMap.Point(113.941637,22.545336);
    map.centerAndZoom(point, 15);
    var marker = new BMap.Marker(point);  // 创建标注
    map.addOverlay(marker);               // 将标注添加到地图中
    marker.setAnimation(BMAP_ANIMATION_BOUNCE); //跳动的动画
  </script>
{% endblock %}

{% block script_extra %}
  {% include '_scripts/pages/post-details.swig' %}
{% endblock %}
