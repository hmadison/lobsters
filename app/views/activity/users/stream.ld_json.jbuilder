json.set! :'@context', 'https://www.w3.org/ns/activitystreams'

json.type 'OrderedCollection'
json.toatlItems @stream_total
json.id @url_method.call(@user)

json.set! :"#{@term}" do |collection|
  collection.type 'CollectionPage'
  collection.id @url_method.call(@user, page: @page)
  collection.partOf @url_method.call(@user)
  collection.next @url_method.call(@user, page: @page + 1) if @term != 'last'

  json.items(@slice) do |element|
    json.partial! element.streamable
  end
end
