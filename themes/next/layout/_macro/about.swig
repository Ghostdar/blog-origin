{% macro render(post, is_index, post_extra_class) %}

  {% set headlessPost = Array.prototype.indexOf.call(['quote', 'picture'], post.type) > -1 %}

  {% set post_class = 'post post-type-' + post.type | default('normal') %}
  {% if post_extra_class > 0 %}
    {% set post_class = post_class + ' ' + post_extra_class | default('') %}
  {% endif %}
  {% if post.sticky > 0 %}
    {% set post_class = post_class + ' ' + 'post-sticky' %}
  {% endif %}

  {% if theme.reading_progress.enable && not is_index %}
    <div class="reading-progress-bar"></div>
  {% endif %}

  <article class="{{ post_class }}" itemscope itemtype="http://schema.org/Article">
  {##################}
  {### POST BLOCK ###}
  {##################}
  <div class="post-block">
    <link itemprop="mainEntityOfPage" href="{{ config.url }}{{ url_for(post.path) }}">

    <span hidden itemprop="author" itemscope itemtype="http://schema.org/Person">
      <meta itemprop="name" content="{{ theme.author }}">
      <meta itemprop="description" content="{{ theme.signature }}">
      <meta itemprop="image" content="{{ url_for( theme.avatar | default(theme.images + '/avatar.gif') ) }}">
    </span>

    <span hidden itemprop="publisher" itemscope itemtype="http://schema.org/Organization">
      <meta itemprop="name" content="{{ config.title }}">
    </span>
    {#################}
    {### ABOUT BODY ###}
    {#################}
    <div class="post-body{% if theme.han %} han-init-context{% endif %}{% if post.direction && post.direction.toLowerCase() === 'rtl' %} rtl{% endif %}" itemprop="articleBody">

      {# Gallery support #}
      {% if post.photos and post.photos.length %}
        <div class="post-gallery" itemscope itemtype="http://schema.org/ImageGallery">
          {% set COLUMN_NUMBER = 3 %}
          {% for photo in post.photos %}
            {% if loop.index0 % COLUMN_NUMBER === 0 %}<div class="post-gallery-row">{% endif %}
              <a class="post-gallery-img fancybox"
                 href="{{ url_for(photo) }}" rel="gallery_{{ post._id }}"
                 itemscope itemtype="http://schema.org/ImageObject" itemprop="url">
                <img src="{{ url_for(photo) }}" itemprop="contentUrl"/>
              </a>
            {% if loop.index0 % COLUMN_NUMBER === 2 %}</div>{% endif %}
          {% endfor %}

          {# Append end tag for `post-gallery-row` when (photos size mod COLUMN_NUMBER) is less than COLUMN_NUMBER #}
          {% if post.photos.length % COLUMN_NUMBER > 0 %}</div>{% endif %}
        </div>
      {% endif %}

      {% if is_index %}
        {% if post.description and theme.excerpt_description %}
          {{ post.description }}
          <!--noindex-->
          <div class="post-button text-center">
            <a class="btn" href="{{ url_for(post.path) }}">
              {{ __('post.read_more') }} &raquo;
            </a>
          </div>
          <!--/noindex-->
        {% elif post.excerpt  %}
          {{ post.excerpt }}
          <!--noindex-->
          <div class="post-button text-center">
            <a class="btn" href="{{ url_for(post.path) }}{% if theme.scroll_to_more %}#{{ __('post.more') }}{% endif %}" rel="contents">
              {{ __('post.read_more') }} &raquo;
            </a>
          </div>
          <!--/noindex-->
        {% elif theme.auto_excerpt.enable %}
          {% set content = post.content | striptags %}
          {{ content.substring(0, theme.auto_excerpt.length) }}
          {% if content.length > theme.auto_excerpt.length %}...{% endif %}
          <!--noindex-->
          <div class="post-button text-center">
            <a class="btn" href="{{ url_for(post.path) }}{% if theme.scroll_to_more %}#{{ __('post.more') }}{% endif %}" rel="contents">
              {{ __('post.read_more') }} &raquo;
            </a>
          </div>
          <!--/noindex-->
        {% else %}
          {% if post.type === 'picture' %}
            <a href="{{ url_for(post.path) }}">{{ post.content }}</a>
          {% else %}
            {{ post.content }}
          {% endif %}
        {% endif %}
      {% else %}
        {{ post.content }}
      {% endif  %}
    </div>

    {% if theme.related_posts.enable and (theme.related_posts.display_in_home or not is_index) %}
      {% include 'post-related.swig' with { post: post } %}
    {% endif %}

    {#####################}
    {### END ABOUT BODY ###}
    {#####################}
    
    <footer class="post-footer">
      {% if post.tags and post.tags.length and not is_index %}
        <div class="post-tags">
          {% for tag in post.tags %}
            <a href="{{ url_for(tag.path) }}" rel="tag"><i class="fa fa-tag"></i> {{ tag.name }}</a>
          {% endfor %}
        </div>
      {% endif %}

      {% if not is_index %}
      {% if theme.rating.enable or (theme.vkontakte_api.enable and theme.vkontakte_api.like) or (theme.facebook_sdk.enable and theme.facebook_sdk.like_button) or (theme.needmoreshare2.enable and theme.needmoreshare2.postbottom.enable) %}
        <div class="post-widgets">
        {% if theme.rating.enable %}
          <div class="wp_rating">
            <div id="wpac-rating"></div>
          </div>
        {% endif %}

        {% if (theme.vkontakte_api.enable and theme.vkontakte_api.like) or (theme.facebook_sdk.enable and theme.facebook_sdk.like_button) %}
          <div class="social-like">
            {% if theme.vkontakte_api.enable and theme.vkontakte_api.like %}
              <div class="vk_like">
                <span id="vk_like"></span>
              </div>
            {% endif %}

            {% if theme.facebook_sdk.enable and theme.facebook_sdk.like_button %}
              <div class="fb_like">
                <div class="fb-like" data-layout="button_count" data-share="true"></div>
              </div>
            {% endif %}
          </div>
        {% endif %}

        {% if theme.needmoreshare2.enable and theme.needmoreshare2.postbottom.enable %}
          {% if (theme.vkontakte_api.enable and theme.vkontakte_api.like) or (theme.facebook_sdk.enable and theme.facebook_sdk.like_button) %}
            <span class="post-meta-divider">|</span>
          {% endif %}
          <div id="needsharebutton-postbottom">
            <span class="btn">
              <i class="fa fa-share-alt" aria-hidden="true"></i>
            </span>
          </div>
        {% endif %}
        </div>
      {% endif %}
      {% endif %}

      {% if not is_index and (post.prev or post.next) %}
        <div class="post-nav">
          <div class="post-nav-next post-nav-item">
            {% if post.next %}
              <a href="{{ url_for(post.next.path) }}" rel="next" title="{{ post.next.title }}">
                <i class="fa fa-chevron-left"></i> {{ post.next.title }}
              </a>
            {% endif %}
          </div>

          <span class="post-nav-divider"></span>

          <div class="post-nav-prev post-nav-item">
            {% if post.prev %}
              <a href="{{ url_for(post.prev.path) }}" rel="prev" title="{{ post.prev.title }}">
                {{ post.prev.title }} <i class="fa fa-chevron-right"></i>
              </a>
            {% endif %}
          </div>
        </div>
      {% endif %}

      {% set isLast = loop.index % page.per_page === 0 %}
      {% if is_index and not isLast %}
        <div class="post-eof"></div>
      {% endif %}
    </footer>
  </div>
  {######################}
  {### END POST BLOCK ###}
  {######################}
  </article>

{% endmacro %}
