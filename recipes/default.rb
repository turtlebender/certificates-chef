# Cookbook Name:: certificates
# Recipe:: default
#
# Deploy one or more X.509 Certificates to a server.
#
# Copyright 2012, University of Chicago
#
# All rights reserved - Do Not Redistribute
#
package "openssl"

cert_descs = node[:certificates][:keys].map do |cert|
  Chef::EncryptedDataBagItem.load(node[:certificates][:data_bag_name], cert)
end


cert_descs.each do |cert_desc|
  ["cert", "cert_chain"].each do |file_type|
    cert_comp = cert_desc[file_type]
    if cert_comp
      file cert_comp["path"] do
        content cert_comp["data"]
        owner cert_desc["owner"] || 'root'
        group cert_desc["group"] || 'root'
        mode 644
      end
    end
    file cert_desc["key"]["path"] do
      content cert_desc["key"]["data"]
      owner cert_desc[:owner] || 'root'
      group cert_desc[:group] || 'root'
      mode 600
    end
  end
end


