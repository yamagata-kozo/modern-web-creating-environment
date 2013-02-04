# coding: utf-8
class StaticFileMaker
  def initialize(rack_app, static_dir = './static')
    # rack-testでrackアプリを作っておく
    @app ||= Rack::Test::Session.new(Rack::MockSession.new(rack_app))
    @static_dir = static_dir
    @timestamp = Time.now.strftime('%Y%m%d%H%M%S')
  end

  def run
    load_site_data
    mkdir_if_not_exist(@static_dir)
    @container_path = "#{ @static_dir }/#{ @timestamp }_#{ @site_data['name'] }"
    mkdir_if_not_exist(@container_path)
    find_and_save_resources(@site_data['tree'])
  end

  def load_site_data(file_path = './site.json')
    @site_data = MultiJson.load(File.open(file_path) {|f| f.read })
  end

  def find_and_save_resources(tree, dirname = nil)
    # ディレクトリ名の頭に / がなければつける
    dirname = "/#{ dirname }" if !dirname.nil? && !(dirname =~ /^\//)
    tree.each do |resource_or_tree|
      # 文字列ならパスにしてページを取得
      if resource_or_tree.class == String
        save "#{ dirname }/#{ resource_or_tree }"
      # 下階層があったらを再起
      elsif resource_or_tree.class == Hash
        resource_or_tree.each do |dir, tree|
          find_and_save_resources(tree, "#{ dirname }/#{ dir }")
        end
      end
    end
  end

  def save(resource)
    res = @app.get(resource)
    if res.errors.length == 0
      # ファイルの保存先ディレクトリが無ければ作成
      resource_array = resource.split('/')
      resource_array.each_with_index do |dir_or_file, i|
        if i != 0 && i != (resource_array.length - 1)
          mkdir_if_not_exist(@container_path + '/' + dir_or_file)
        end
      end
      # ファイルの内容を保存
      html_file = File.new("#{ @container_path }#{ resource }", 'w')
      html_file.write(res.body)
      html_file.close
    end
  end

  def mkdir_if_not_exist(path)
    Dir.mkdir(path) unless File.exists?(path)
  end
end

