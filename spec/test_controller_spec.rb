# frozen_string_literal: true

describe TestController, type: :controller do
  render_views

  describe 'usage of default locale' do
    before do
      get :locales
    end

    describe 'response' do
      subject { response }

      it { is_expected.to have_http_status :ok }

      describe 'body' do
        subject { super().body }

        it { is_expected.to eq 'ru' }
      end
    end
  end

  describe 'getting locale from param' do
    before do
      get :locales, params: { locale: 'fr' }
    end

    describe 'response' do
      subject { response }

      it { is_expected.to have_http_status :ok }

      describe 'body' do
        subject { super().body }

        it { is_expected.to eq 'fr, ru' }
      end
    end
  end

  describe 'getting locale from session' do
    before do
      get :locales, session: { locale: 'fr' }
    end

    describe 'response' do
      subject { response }

      it { is_expected.to have_http_status :ok }

      describe 'body' do
        subject { super().body }

        it { is_expected.to eq 'fr, ru' }
      end
    end
  end

  describe 'locales from http' do
    before do
      request.env['HTTP_ACCEPT_LANGUAGE'] = http_header
      get :locales
    end

    context 'with regular locales' do
      let(:http_header) { 'ru,fr;q=0.9' }

      describe 'response' do
        subject { response }

        it { is_expected.to have_http_status :ok }

        describe 'body' do
          subject { super().body }

          it { is_expected.to eq 'ru, fr' }
        end
      end
    end

    context 'with wildcard' do
      let(:http_header) { '*' }

      describe 'response' do
        subject { response }

        it { is_expected.to have_http_status :ok }

        describe 'body' do
          subject { super().body }

          it { is_expected.to eq 'ru' }
        end
      end
    end

    context 'with regular locales and wildcard' do
      let(:http_header) { 'ru, fr;q=0.9, *;q=0.5' }

      describe 'response' do
        subject { response }

        it { is_expected.to have_http_status :ok }

        describe 'body' do
          subject { super().body }

          it { is_expected.to eq 'ru, fr' }
        end
      end
    end
  end

  describe 'loading translations' do
    before do
      get :translations, params: { locale: 'en' }
    end

    describe 'response' do
      subject { response }

      it { is_expected.to have_http_status :ok }

      describe 'body' do
        subject { super().body }

        it { is_expected.to eq 'R18n: supported. Rails I18n: supported' }
      end
    end
  end

  describe 'returning available translations' do
    before do
      get :available
    end

    describe 'response' do
      subject { response }

      it { is_expected.to have_http_status :ok }

      describe 'body' do
        subject { super().body }

        it { is_expected.to eq 'en ru' }
      end
    end
  end

  describe 'adding helpers' do
    before do
      get :helpers, params: { locale: 'en' }
    end

    describe 'response' do
      subject { response }

      it { is_expected.to have_http_status :ok }

      describe 'body' do
        subject { super().body }

        it { is_expected.to eq "Name\nName\nName\nName\n" }
      end
    end
  end

  describe 'formatting untranslated' do
    before do
      get :untranslated
    end

    describe 'response' do
      subject { response }

      it { is_expected.to have_http_status :ok }

      describe 'body' do
        subject { super().body }

        it { is_expected.to eq 'user.<span style="color: red">[not.exists]</span>' }
      end
    end
  end

  describe 'adding methods to controller' do
    before do
      get :controller, params: { locale: 'en' }
    end

    describe 'response' do
      subject { response }

      it { is_expected.to have_http_status :ok }

      describe 'body' do
        subject { super().body }

        it { is_expected.to eq 'Name Name Name' }
      end
    end
  end

  describe 'localization time by Rails I18n' do
    before do
      get :time, params: { locale: 'en' }
    end

    describe 'response' do
      subject { response }

      it { is_expected.to have_http_status :ok }

      describe 'body' do
        subject { super().body }

        it { is_expected.to eq "Thu, 01 Jan 1970 00:00:00 +0000\n01 Jan 00:00" }
      end
    end
  end

  describe 'localization time by R18n' do
    before do
      get :human_time, params: { locale: 'en' }
    end

    describe 'response' do
      subject { response }

      it { is_expected.to have_http_status :ok }

      describe 'body' do
        subject { super().body }

        it { is_expected.to eq 'now' }
      end
    end
  end

  describe 'models translation' do
    before do
      ActiveRecord::Schema.verbose = false

      ActiveRecord::Schema.define(version: 20_091_218_130_034) do
        create_table 'posts', force: true do |t|
          t.string 'title_en'
          t.string 'title_ru'
        end
      end
    end

    describe 'unlocalized_getters' do
      subject { Post.unlocalized_getters(:title) }

      it { is_expected.to include 'ru' => 'title_ru', 'en' => 'title_en' }
    end

    describe 'unlocalized_setters' do
      subject { Post.unlocalized_setters(:title) }

      it { is_expected.to eq 'ru' => 'title_ru=', 'en' => 'title_en=' }
    end

    describe 'instance' do
      let(:post) { Post.new }

      before do
        # Default locale is `ru`
        post.title_ru = 'Запись'
      end

      context 'when locale changed' do
        before do
          R18n.set 'en'
        end

        specify do
          expect(post.title).to eq 'Запись'
        end

        context 'when a new value assigned' do
          before do
            post.title = 'Record'
          end

          specify do
            expect(post.title_ru).to eq 'Запись'
          end

          specify do
            expect(post.title_en).to eq 'Record'
          end

          specify do
            expect(post.title).to eq 'Record'
          end
        end
      end
    end
  end

  describe 'setting default places' do
    subject { R18n.default_places }

    it { is_expected.to eq [Rails.root.join('app/i18n'), R18n::Loader::Rails.new] }

    context 'when locale has been changed' do
      before do
        R18n.set('en')
      end

      describe 'translation' do
        subject { R18n.get.user.name }

        it { is_expected.to eq 'Name' }
      end
    end
  end

  describe 'mails translation' do
    subject(:email) { TestMailer.test.deliver_now }

    around do |example|
      I18n.with_locale 'en' do
        example.run
      end
    end

    describe 'email body' do
      subject { email.body.to_s }

      it { is_expected.to eq "Name\nName\nName\n" }
    end
  end

  describe 'reloading filters from app directory' do
    before do
      get :filter, params: { locale: 'en' }
    end

    describe 'response' do
      subject { response }

      it { is_expected.to have_http_status :ok }

      describe 'body' do
        subject { super().body }

        it { is_expected.to eq 'Rails' }
      end
    end

    describe 'loaded filters' do
      subject { R18n::Rails::Filters.loaded }

      it { is_expected.to eq [:rails_custom_filter] }
    end

    context 'when new filter added' do
      before do
        R18n::Filters.defined[:rails_custom_filter].block = proc { 'No' }

        get :filter, params: { locale: 'en' }
      end

      describe 'response' do
        subject { response }

        it { is_expected.to have_http_status :ok }

        describe 'body', pending: "I don't know how to test this correctly" do
          subject { super().body }

          it { is_expected.to eq 'No' }
        end
      end
    end
  end

  describe 'escaping html inside R18n' do
    before do
      get :safe, params: { locale: 'en' }
    end

    describe 'response' do
      subject { response }

      it { is_expected.to have_http_status :ok }

      describe 'body' do
        subject { super().body }

        it { is_expected.to eq "<b> user.<span style=\"color: red\">[no_tr]</span>\n" }
      end
    end
  end

  describe 'work with Rails build-in helpers' do
    before do
      get :format
    end

    describe 'response' do
      subject { response }

      it { is_expected.to have_http_status :ok }

      describe 'body' do
        subject { super().body }

        it { is_expected.to eq "1 000,1 руб.\n" }
      end
    end
  end

  describe 'caching I18n object' do
    subject { R18n.cache.keys.length }

    before do
      R18n.clear_cache!

      get :translations
    end

    it { is_expected.to eq 1 }

    describe 'second request' do
      before do
        get :translations
      end

      it { is_expected.to eq 1 }

      describe 'third request with custom header' do
        before do
          request.env['HTTP_ACCEPT_LANGUAGE'] = 'ru,fr;q=0.9'
          get :translations
        end

        it { is_expected.to eq 1 }

        describe 'fourth request with custom param' do
          before do
            get :translations, params: { locale: 'en' }
          end

          it { is_expected.to eq 2 }
        end
      end
    end
  end

  it 'parameterizes strigns' do
    expect('One two три'.parameterize).to eq 'one-two'
  end
end
