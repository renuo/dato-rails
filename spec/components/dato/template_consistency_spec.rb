require "rails_helper"
require "digest"

RSpec.describe "Template consistency" do
  let(:gem_root) { Pathname.new(__dir__).join("../../..").expand_path }

  def md5_hash(component)
    Digest::MD5.hexdigest(File.read(gem_root.join("app", "components", "dato", "#{component}.html.erb")))
  end

  describe "HTML templates must match dast_node.html.erb" do
    let(:reference_md5) { md5_hash("dast_node") }

    it "paragraph.html.erb matches dast_node.html.erb" do
      component_md5 = md5_hash("paragraph")
      expect(component_md5).to eq(reference_md5)
    end

    it "heading.html.erb matches dast_node.html.erb" do
      component_md5 = md5_hash("heading")
      expect(component_md5).to eq(reference_md5)
    end

    it "list.html.erb matches dast_node.html.erb" do
      component_md5 = md5_hash("list")
      expect(component_md5).to eq(reference_md5)
    end

    it "list_item.html.erb matches dast_node.html.erb" do
      component_md5 = md5_hash("list_item")
      expect(component_md5).to eq(reference_md5)
    end
  end
end
