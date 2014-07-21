defmodule WsTest do
  use ExUnit.Case

  # These test the functions underling the controller functions.
  
  test "updateBirdStructInList" do
    bird_0 = %Ws.Models.Bird{name: "bird0", type: "phoenix", age: 0}
    bird_1 = %Ws.Models.Bird{name: "bird1", type: "phoenix", age: 1}
    bird_2 = %Ws.Models.Bird{name: "bird2", type: "phoenix", age: 2}
    bird_list = [bird_0, bird_1, bird_2]
    bird_name = "bird1"
    new_bird = %Ws.Models.Bird{name: "bird3", type: "whippet", age: 3}
    {found0, new_list0} = Ws.Controllers.Birds.updateBirdStructInList(bird_list, bird_name, new_bird)
    assert found0 == true
    [head0 | tail0] = new_list0
    assert head0.name === "bird0"
    [head1 | _] = tail0
    assert head1.name === "bird3"

    {found1, _new_list1} = Ws.Controllers.Birds.updateBirdStructInList(new_list0, "bird5", new_bird)
    assert found1 == false
  end

  test "deleteBirdStructInList" do
    bird_0 = %Ws.Models.Bird{name: "bird0", type: "phoenix", age: 0}
    bird_1 = %Ws.Models.Bird{name: "bird1", type: "phoenix", age: 1}
    bird_2 = %Ws.Models.Bird{name: "bird2", type: "phoenix", age: 2}
    bird_list = [bird_0, bird_1, bird_2]
    {found0, new_list0} = Ws.Controllers.Birds.deleteBirdStructInList(bird_list, "bird1")
    assert found0 == true
    [head0 | tail0] = new_list0
    assert head0.name === "bird0"
    [head1 | _] = tail0
    assert head1.name === "bird2"

    {found1, _new_list1} = Ws.Controllers.Birds.deleteBirdStructInList(new_list0, "bird1")
    assert found1 == false
  end
end
