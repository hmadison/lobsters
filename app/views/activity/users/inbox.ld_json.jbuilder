json.set! :'@context', 'https://www.w3.org/ns/activitystreams'

json.type 'OrderedCollection'
json.toatlItems @stream_total
json.id inbox_activity_user_url(@user, domain: Rails.application.domain)

json.set! :"#{@term}" do |collection|
  collection.type 'CollectionPage'
  collection.id inbox_activity_user_url(@user, domain: Rails.application.domain, page: @page)
  collection.partOf inbox_activity_user_url(@user, domain: Rails.application.domain)
  collection.next inbox_activity_user_url(@user, domain: Rails.application.domain, page: @page + 1) if @term != 'last'

  json.items(@slice) do |element|
    json.partial! element.streamable
  end
end
