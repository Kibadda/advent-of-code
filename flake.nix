{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }: let
    system = "x86_64-linux";
  in {
    devShells.${system}.default = let
      pkgs = import nixpkgs { inherit system; };
    in pkgs.mkShell {
      name = "advent-of-code";
      buildInputs = [
        (pkgs.writeShellApplication {
            name = "aoc";
            runtimeInputs = with pkgs; [
              aoc-cli
              luajit
              jq
            ];
            text = ''
              wrapper() {
                aoc -s ./aoc.session "$@"
              }

              if [ "$#" -eq 0 ]; then
                wrapper help
                exit 0
              fi

              case "$1" in
                r)
                  if [ "$#" -lt 3 ]; then
                    exit 1
                  fi
                  test=0
                  if [ "$#" -eq 4 ]; then
                    test=$4
                  fi
                  pushd ./lua
                  luajit "advent-of-code/$2/$3/init.lua" "$test"
                  popd
                  ;;
                s)
                  if [ "$#" -lt 5 ]; then
                    exit 1
                  fi
                  wrapper s -y "$2" -d "$3" "$4" "$5"
                  ;;
                d)
                  if [ "$#" -lt 3 ]; then
                    exit 1
                  fi
                  wrapper d -y "$2" -d "$3" -p "lua/advent-of-code/$2/$3/puzzle.md" -i "lua/advent-of-code/$2/$3/input.txt" -o
                  ;;
                n)
                  if [ "$#" -lt 3 ]; then
                    exit 1
                  fi
                  DIR="./lua/advent-of-code/$2/$3"
                  if [[ -d "$DIR/" ]]; then
                    echo "$DIR already exists; exiting"
                  else
                    mkdir -p "$DIR"
                    wrapper d -i "$DIR/input.txt" -p "$DIR/puzzle.md" -y "$2" -d "$3"
                    touch "$DIR/test.txt"
                    cp "lua/advent-of-code/day_template.lua" "$DIR/init.lua"
                    sed -i "s/YEAR/$2/g; s/DAY/$3/g" "$DIR/init.lua"
                  fi
                  ;;
                t)
                  if [ "$#" -lt 3 ]; then
                    exit 1
                  fi
                  THRESHOLD_SEC="''${THRSHOLD_SEC:-1}"
                  THRESHOLD_US=$(awk "BEGIN {print $THRESHOLD_SEC * 1000000}")
                  sum_parse=0
                  sum_one=0
                  sum_two=0
                  runtime=0
                  count=0
                  pushd ./lua
                  while true
                  do
                    count=$((count + 1))
                    json="$(TIMINGS=1 luajit "advent-of-code/$2/$3/init.lua")"
                    start=$(jq -r '.start' <<<"$json")
                    parse=$(jq -r '.parse' <<<"$json")
                    one=$(jq -r '.one' <<<"$json")
                    two=$(jq -r '.two' <<<"$json")
                    d_parse=$((parse - start))
                    d_one=$((one - parse))
                    d_two=$((two - one))
                    d_all=$((two - start))
                    sum_parse=$((sum_parse + d_parse))
                    sum_one=$((sum_one + d_one))
                    sum_two=$((sum_two + d_two))
                    runtime=$((runtime + d_all))
                    if (( runtime > THRESHOLD_US )); then
                      break
                    fi
                  done
                  avg_parse=$((sum_parse))
                  avg_one=$((sum_one))
                  avg_two=$((sum_two))
                  if (( count > 0 )); then
                    avg_parse=$((sum_parse / count))
                    avg_one=$((sum_one / count))
                    avg_two=$((sum_two / count))
                  fi
                  echo "Averaged over $count runs:"
                  echo "  parse:  $avg_parse"
                  echo "  one:    $avg_one"
                  echo "  two:    $avg_two"
                  popd
                  ;;
                *)
                  wrapper "$@"
                  ;;
              esac
            '';
        })
      ];
    };
  };
}
