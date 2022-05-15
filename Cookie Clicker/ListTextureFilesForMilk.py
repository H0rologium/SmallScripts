import os

def main():
    #os.chdir("E:")
    smp = "E:/Steam/steamapps/common/Cookie Clicker/resources/app/src/img"
    lmp = "E:/Steam/steamapps/common/Cookie Clicker/resources/app/mods/local/lean milk"
    results = []
    for file in os.listdir(smp):
        if "milk" in file:
            results.append(file)
    print(results)
    #Write to new txt (temporary)
    file = open(lmp+"/output.txt","w+")
    for item in results:
        file.write("Game.Loader.Replace('"+item+"',this.dir+'/"+item[0:len(item)-4:1]+"lean.png');\n")
    #Wrapup
    file.close()
    return


if __name__=="__main__":
    main()
